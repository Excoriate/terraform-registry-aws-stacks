locals {
  aws_region_to_deploy = var.aws_region

  /*
   * Feature flags
  */
  is_enabled                            = var.is_enabled
  is_http_enabled                       = !local.is_enabled ? false : var.http_config.enable_http
  is_https_enabled                      = !local.is_enabled ? false : var.http_config.enable_https
  is_dns_record_generation_enabled      = !local.is_enabled ? false : var.http_config.dns_record == null ? false : var.http_config.dns_record != ""
  is_https_redirection_enabled          = !local.is_enabled ? false : var.http_config.enable_forced_redirection_to_https
  is_fronting_a_backend_service_enabled = !local.is_enabled ? false : var.http_config.is_backend_service

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


  vpc_name_normalised = !local.is_enabled ? null : lower(trimspace(var.vpc_name))
  // The domain name and the zone_name for this purpose are the same.
  domain_name_normalised = !local.is_enabled ? null : lower(trimspace(var.http_config.domain))
}
