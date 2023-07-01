data "aws_ses_domain_identity" "this" {
  for_each = !local.is_user_pool_email_config_enabled ? {} : local.stack_create
  domain   = lookup(var.user_pool_ses_email_config, "domain")

  depends_on = [
    module.auth_ses
  ]
}
