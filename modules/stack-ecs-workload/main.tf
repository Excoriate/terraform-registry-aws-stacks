locals {
  vpc_data            = !local.is_enabled ? null : lookup(module.network_data[local.stack]["vpc_data"], local.vpc_name_normalised)
  subnet_private_az_a = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_private_az_a_data"], local.vpc_name_normalised)
  subnet_private_az_b = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_private_az_b_data"], local.vpc_name_normalised)
  subnet_private_az_c = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_private_az_c_data"], local.vpc_name_normalised)

  vpc_id         = lookup(local.vpc_data, "id")
  subnet_az_a_id = lookup(local.subnet_private_az_a, "id")
  subnet_az_b_id = lookup(local.subnet_private_az_b, "id")
  subnet_az_c_id = lookup(local.subnet_private_az_c, "id")
}

// ***************************************
// 1. Fetch VPC and network-related data.
// ***************************************
module "network_data" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data?ref=v1.29.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  // Fetch VPC and network-related data.
  vpc_data = {
    name                     = local.vpc_name_normalised
    retrieve_subnets_private = true
    filter_by_az             = true
  }

  tags = local.tags
}

locals {
  alb_data  = !local.is_enabled ? null : data.aws_alb.this
  alb_sg_id = !local.is_enabled ? null : join("", [for sg in data.aws_security_group.alb_sg : sg.id])
}

// ***************************************
// 2. ECS/Backend security group
// ***************************************
module "ecs_security_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group?ref=v1.30.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  security_group_config = [
    {
      name        = format("%s-ecs-sg", local.stack_full)
      description = format("Firewall set of rules for %s stack", local.stack_full)
      vpc_id      = local.vpc_id
    }
  ]

  security_group_rules_ooo = [
    {
      sg_parent                              = format("%s-ecs-sg", local.stack_full)
      enable_all_outbound_traffic            = true
      enable_inbound_https_from_source       = local.is_https_enabled
      enable_inbound_http_from_source        = local.is_http_enabled
      source_security_group_id               = local.alb_sg_id
      enable_outbound_https                  = true
      enable_outbound_http                   = true
      custom_port                            = var.port_config.container_port
      enable_inbound_from_custom_port_source = true
    }
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

// ***************************************
// 3. Cloudwatch log-group.
// ***************************************
module "ecs_log_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-observability//modules/aws/cloudwatch-log-group?ref=v0.1.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  log_group_config = [
    {
      name = local.cloudwatch_log_group_name
    }
  ]

  tags = local.tags
}

// ***************************************
// 4. Elastic Container Registry
// ***************************************
locals {
  is_ecr_built_in_enabled = !var.is_enabled ? false : var.enable_built_in_container_registry_config == null ? false : lookup(var.enable_built_in_container_registry_config, "is_enabled", false)
}
module "ecs_container_registry" {
  for_each   = !local.is_ecr_built_in_enabled ? {} : local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecr?ref=v1.1.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled
  ecr_lifecycle_policy_config = {
    name          = lookup(var.enable_built_in_container_registry_config, "repository_name", local.stack_full)
    max_image_count = 500
    protected_tags  = ["latest", "prod", "dev", "stage", "sandbox", "master", "legacy", "int"]
  }
  ecr_config = [{
    name                 = lookup(var.enable_built_in_container_registry_config, "repository_name", local.stack_full)
    scan_on_push         = true
    force_delete         = true
  }]
  tags = local.tags
}


// ***************************************
// 4. Container definition
// ***************************************
module "ecs_container_definition" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-container-definition?ref=v0.17.0"

#  container_image  = local.container_image
  container_image  = !local.is_ecr_built_in_enabled ? local.container_image : module.ecs_container_registry[local.stack].ecr_repository_url[0]
  container_name   = local.workload_name_normalised
  container_memory = var.container_config.memory
  container_cpu    = var.container_config.cpu
  essential        = var.container_config.essential
  environment      = var.container_config.environment_variables
  port_mappings = [
    {
      containerPort = var.port_config.container_port
      hostPort      = var.port_config.container_port
      protocol      = "tcp"
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = local.cloudwatch_log_group_name
      "awslogs-region"        = var.aws_region
      "awslogs-stream-prefix" = format("log-%s", local.workload_name_normalised)
    }
  }

  depends_on = [
    module.ecs_log_group
  ]
}

// ***************************************
// 5. ECS execution role
// ***************************************
module "ecs_execution_role" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles?ref=v0.17.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/ecs-roles"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  execution_role_ooo_config = [
    {
      name                    = local.container_exec_role_name
      role_name               = local.container_exec_role_name
      enable_ooo_role_fargate = true
    }
  ]
}

// ***************************************
// 6. ECS task role
// ***************************************
module "ecs_task_role" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles?ref=v0.17.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/ecs-roles"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  task_role_config = [
    {
      name      = local.container_task_role_name
      role_name = local.container_task_role_name
    }
  ]

  task_role_permissions_config = local.task_permissions
}



// ***************************************
// 7. ECS task definition
// ***************************************
locals {
  execution_role_arn = join("", [for r in data.aws_iam_role.execution_role : r.arn])
  task_role_arn      = join("", [for r in data.aws_iam_role.task_role : r.arn])
}

module "ecs_task_definition" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-task?ref=v0.17.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/ecs-task"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  task_config = [
    {
      name                             = local.stack_full
      family                           = format("task-def-%s", local.workload_name_normalised)
      cpu                              = var.container_config.cpu
      memory                           = var.container_config.memory
      network_mode                     = "awsvpc"
      container_definition_from_json   = module.ecs_container_definition[local.stack].json_map_encoded_list
      manage_task_outside_of_terraform = var.manage_ecs_service_out_of_terraform
    }
  ]

  task_permissions_config = [
    {
      name                         = local.stack_full
      task_role_arn                = local.task_role_arn
      execution_role_arn           = local.execution_role_arn
      disable_built_in_permissions = true
    }
  ]

  tags = local.tags
}

// ***************************************
// 8. ECS service
// ***************************************
locals {
  cluster             = join("", [for c in data.aws_ecs_cluster.this : c.cluster_name])
  task_definition_arn = join("", module.ecs_task_definition[local.stack].ecs_task_definition_arn)
  ecs_security_groups = [for sg in module.ecs_security_group[local.stack].sg_id : sg]
  ecs_subnets         = [local.subnet_az_a_id, local.subnet_az_b_id, local.subnet_az_c_id]
  ecs_load_balancers_config = !local.is_alb_attachment_by_ecs_enabled ? null : [for tg_data in data.aws_lb_target_group.tg_to_attach : {
    target_group_arn = tg_data.arn
    container_name   = local.workload_name_normalised
    container_port   = var.port_config.container_port
  }]
}

module "ecs_service" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-service?ref=v0.17.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/ecs-service"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  ecs_service_config = [
    {
      cluster                                  = local.cluster
      desired_count                            = var.scaling_base_capacity
      name                                     = local.ecs_service_name_normalised
      task_definition                          = local.task_definition_arn
      enable_ignore_changes_on_desired_count   = var.manage_ecs_service_out_of_terraform
      enable_ignore_changes_on_task_definition = var.manage_ecs_service_out_of_terraform
      network_config = {
        mode             = "awsvpc"
        subnets          = local.ecs_subnets
        security_groups  = local.ecs_security_groups
        assign_public_ip = false
      }
      // Optional load-balancer (actually target groups to attach)
      load_balancers_config = local.ecs_load_balancers_config
    }
  ]

  ecs_service_permissions_config = [
    {
      name                         = local.ecs_service_name_normalised
      execution_role_arn           = local.execution_role_arn
      disable_built_in_permissions = true
    }
  ]

  depends_on = [
    module.ecs_execution_role,
    module.ecs_task_role,
    module.ecs_security_group
  ]
}

// ***************************************
// 9. Allow ALB to reach ECS
// (this module attach extra rules to the ALB)
// ***************************************
locals {
  ecs_sg_id = !local.is_alb_attachment_by_ecs_enabled ? null : data.aws_security_group.ecs_sg[local.stack].id
}

resource "aws_security_group_rule" "outbound_traffic_to_ecs_from_alb" {
  for_each                 = !local.is_alb_attachment_by_ecs_enabled ? {} : local.stack_config_map
  type                     = "egress"
  from_port                = var.port_config.container_port
  to_port                  = var.port_config.container_port
  protocol                 = "tcp"
  security_group_id        = local.alb_sg_id
  source_security_group_id = local.ecs_sg_id

  depends_on = [
    data.aws_security_group.ecs_sg,
    data.aws_security_group.alb_sg
  ]
}


// ***************************************
// 10. ECS auto-scaling
// ***************************************
module "ecs_auto_scaling" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/auto-scaling/app-auto-scaling?ref=v0.17.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/auto-scaling"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  auto_scaling_ecs_config = [
    {
      name         = local.stack_full
      min_capacity = var.scaling_base_capacity
      max_capacity = var.scaling_up_max_capacity
      cluster_name = local.cluster_name_normalised
      service_name = local.ecs_service_name_normalised
    }
  ]

  depends_on = [
    module.ecs_service
  ]
}
