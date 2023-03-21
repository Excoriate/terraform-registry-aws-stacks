// ***************************************
// 1. Create a secret
// ***************************************
module "secret" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-storage//modules/secrets-manager?ref=v0.7.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  secrets_config = [
    {
      name                    = local.stack
      path                    = var.secret_name
      recovery_window_in_days = var.recovery_window_in_days
    }
  ]

  enforced_prefixes = !local.is_prefix_enforcement_enabled ? null : [{
    name   = var.secret_name
    prefix = var.secret_prefix_enforced
  }]

  secrets_replication_config = !local.is_replication_enabled ? null : [for region in var.replicate_in_regions : {
    region = trimspace(region)
    name   = var.secret_name
  }]

  tags = local.tags
}

// ***************************************
// 2. Built-in IAM policies
// ***************************************
module "permission" {
  for_each   = !local.is_permissions_enabled ? {} : local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-storage//modules/secrets-manager-permissions?ref=v0.7.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  secret_permissions = [
    {
      name        = local.stack
      secret_name = var.secret_name
      permissions = var.permissions
    }
  ]

  tags = local.tags

  depends_on = [
    module.secret
  ]
}
