locals {
  aws_region_to_deploy = var.aws_region

  /*
   * Feature flags
  */
  is_enabled                    = var.is_enabled
  is_prefix_enforcement_enabled = !local.is_enabled ? false : var.secret_prefix_enforced != null
  is_replication_enabled        = !local.is_enabled ? false : var.replicate_in_regions != null
  is_permissions_enabled        = !local.is_enabled ? false : var.permissions == null ? false : length(var.permissions) > 0

  tags = local.is_enabled ? merge(
    {
      "Stack" = local.stack_full
    },
    var.tags,
  ) : {}

  stack_config = !local.is_enabled ? [] : [
    {
      name   = lower(trimspace(var.stack))
      prefix = lower(trimspace(var.stack_prefix))
      full   = format("%s-%s", lower(trimspace(var.stack_prefix)), lower(trimspace(var.stack)))
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
  stack_full = !local.is_enabled ? null : format("%s-%s", lower(trimspace(var.stack_prefix)), lower(trimspace(var.stack)))

}
