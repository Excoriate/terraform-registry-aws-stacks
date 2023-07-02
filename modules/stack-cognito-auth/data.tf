data "aws_ses_domain_identity" "this" {
  for_each = !local.is_user_pool_email_config_enabled ? {} : local.stack_create
  domain   = lookup(var.user_pool_ses_email_config, "domain")

  depends_on = [
    module.auth_ses
  ]
}

data "aws_cognito_user_pools" "this" {
  for_each = !local.is_identity_provider_config_enabled ? {} : local.stack_create
  name     = each.value

  depends_on = [
    module.auth_cognito_user_pool
  ]
}
