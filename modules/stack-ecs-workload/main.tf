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
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data?ref=v1.20.0"
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
  alb_sg_id = !local.is_enabled ? null : join("", [for sg in data.aws_security_group.this : sg.id])
}

// ***************************************
// 2. ECS/Backend security group
// ***************************************
module "ecs_security_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group?ref=v1.21.0"
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
      sg_parent                        = format("%s-ecs-sg", local.stack_full)
      enable_all_outbound_traffic      = true
      enable_inbound_https_from_source = local.is_https_enabled
      enable_inbound_http_from_source  = local.is_http_enabled
      source_security_group_id         = local.alb_sg_id
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
// 4. Container definition
// ***************************************
module "ecs_container_definition" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-container-definition?ref=v0.7.0"

  container_image  = var.container_config.image
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
// 6. ECS task execution role
// ***************************************
module "ecs_execution_role" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles?ref=v0.7.0"
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
// 7. ECS task role
// ***************************************
module "ecs_task_role" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles?ref=v0.7.0"
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
// 8. ECS task definition
// ***************************************
locals {
  execution_role_arn = join("", [for r in data.aws_iam_role.execution_role : r.arn])
  task_role_arn      = join("", [for r in data.aws_iam_role.task_role : r.arn])
}
module "ecs_task_definition" {
  for_each = local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-task?ref=v0.7.0"
  #  source   = "../../../terraform-registry-aws-containers/modules/ecs-task"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  task_config = [
    {
      name                           = local.stack_full
      family                         = format("task-def-%s", local.workload_name_normalised)
      cpu                            = var.container_config.cpu
      memory                         = var.container_config.memory
      network_mode                   = "awsvpc"
      container_definition_from_json = module.ecs_container_definition[local.stack].json_map_encoded_list
      enable_default_permissions     = true
      // Permissions from a data-source, after the module create these resources.
      task_role_arn      = local.task_role_arn
      execution_role_arn = local.execution_role_arn
    }
  ]

  tags = local.tags
}
