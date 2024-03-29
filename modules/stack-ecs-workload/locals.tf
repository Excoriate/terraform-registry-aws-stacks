locals {
  aws_region_to_deploy = var.aws_region

  /*
    - Control feature flags
    - Whether the entire module is enabled.
    - Whether the http option is enabled: this dictates sg rules.
    - Whether the https option is enabled: this dictates sg rules.
  */
  is_enabled       = var.is_enabled
  is_http_enabled  = !local.is_enabled ? false : var.http_config.enable_http
  is_https_enabled = !local.is_enabled ? false : var.http_config.enable_https
  is_sg_groups_interoperability_enabled = !local.is_enabled ? false : var.enable_built_in_interoperability_alb_ecs_config

  tags = local.is_enabled ? merge(
    {
      "Stack" = local.stack_full
    },
    var.tags,
  ) : {}

  stack_config = !local.is_enabled ? [] : [
    {
      name   = lower(trimspace(var.stack))
      prefix = var.stack_prefix == null ? "" : lower(trimspace(var.stack_prefix))
      full   = var.stack_prefix == null ? lower(trimspace(var.stack)) : format("%s-%s", lower(trimspace(var.stack_prefix)), lower(trimspace(var.stack)))
    }
  ]

  // Create a map with the key as the stack name
  stack_config_map = !local.is_enabled ? {} : {
    for stack in local.stack_config :
    stack["name"] => {
      name   = stack["name"]
      prefix = stack["prefix"]
      full   = stack["full"]
    }
  }

  stack      = !local.is_enabled ? null : lower(trimspace(var.stack))
  stack_full = !local.is_enabled ? null : var.stack_prefix == null ? lower(trimspace(var.stack)) : format("%s-%s", lower(trimspace(var.stack_prefix)), lower(trimspace(var.stack)))

  vpc_name_normalised         = !local.is_enabled ? null : lower(trimspace(var.vpc_name))
  workload_name_normalised    = !local.is_enabled ? null : lower(trimspace(var.workload_name))
  ecs_service_name_normalised = !local.is_enabled ? null : lower(trimspace(format("%s-ecs", var.workload_name)))
  cluster_name_normalised     = !local.is_enabled ? null : lower(trimspace(var.cluster))
  cloudwatch_log_group_name   = !local.is_enabled ? null : format("/aws/ecs/%s/%s-logs", local.cluster_name_normalised, local.ecs_service_name_normalised)

  /*
    * Configuration for the ECS execution role, and ECS Task role.
    * 1. ECS execution role is used by ECS to run tasks on the EC2 instances.
    * 2. ECS task role is used by the containers to access AWS resources.
  */
  container_exec_role_name = format("role-%s-%s", local.stack_full, local.workload_name_normalised)
  container_task_role_name = format("role-%s-%s", local.stack_full, local.workload_name_normalised)


  // 2. ECS task role (and permissions)
  task_permissions = !local.is_enabled ? null : var.container_config["permissions"] == null ? [{
    resources                      = ["*"]
    policy_name                    = format("pol-default-%s", local.workload_name_normalised)
    role_name                      = local.container_task_role_name
    merge_with_default_permissions = true
    actions                        = ["*"]
    type                           = "Allow"
    }] : [
    for permission in var.container_config["permissions"] :
    {
      resources                      = permission["resources"]
      policy_name                    = trimspace(permission["policy_name"])
      role_name                      = local.container_task_role_name
      merge_with_default_permissions = true
      actions                        = permission["actions"]
      type                           = permission["type"]
    }
  ]

  /*
    * The 'tag' is also propagated, however it's an optional value. If it's passed, it'll be used.
  */
  container_image_url_include_tag = !local.is_enabled ? false : length(split(":", trimspace(var.container_config.image_url))) > 1
  image_url                       = local.container_image_url_include_tag ? split(":", trimspace(var.container_config.image_url))[0] : trimspace(var.container_config.image_url)
  image_tag                       = local.container_image_url_include_tag ? split(":", trimspace(var.container_config.image_url))[1] : var.container_config.image_tag == null ? "latest" : trimspace(var.container_config.image_tag)
  container_image                 = format("%s:%s", local.image_url, local.image_tag)

  is_alb_attachment_by_ecs_enabled = !local.is_enabled ? false : var.attach_ingress_alb_target_group_by_name == null ? false : length(var.attach_ingress_alb_target_group_by_name) > 0 ? true : false
  target_groups_to_attach = !local.is_alb_attachment_by_ecs_enabled ? {} : {
    for tg in var.attach_ingress_alb_target_group_by_name :
    tg => {
      stack = local.stack
      name  = tg
    }
  }
}
