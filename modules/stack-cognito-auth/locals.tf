locals {
  aws_region_to_deploy = var.aws_region
  /*
  Feature flags
  */
  is_enabled                                                = var.is_enabled
  is_user_pool_sms_verification_enabled                     = !local.is_enabled ? false : var.user_pool_sms_verification_config != null
  is_user_pool_email_verification_enabled                   = !local.is_enabled ? false : var.user_pool_email_verification_config != null
  is_user_pool_mfa_configuration_enabled                    = !local.is_enabled ? false : var.user_pool_mfa_configuration_config != null
  is_user_pool_admin_create_user_config_enabled             = !local.is_enabled ? false : var.user_pool_admin_create_user_config != null
  is_user_pool_account_recovery_config_enabled              = !local.is_enabled ? false : var.user_pool_account_recovery_config != null
  is_user_pool_email_config_enabled                         = !local.is_enabled ? false : var.user_pool_ses_email_config != null
  is_user_pool_sms_configuration_enabled                    = !local.is_enabled ? false : var.user_pool_sms_configuration != null
  is_user_pool_schema_attributes_config_enabled             = !local.is_enabled ? false : var.schema_attributes_config != null
  is_user_pool_verification_message_template_config_enabled = !local.is_enabled ? false : var.verification_message_template_config != null
  is_user_pool_lambda_config_enabled                        = !local.is_enabled ? false : var.lambda_config != null

  // Naming convention
  stack  = !local.is_enabled ? null : lower(trimspace(var.stack))
  prefix = !local.is_enabled ? null : !var.enable_stack_prefix ? null : local.stack

  tags = local.is_enabled ? merge(
    {
      "Stack" = local.stack
    },
    var.tags,
  ) : {}

  // User pool configuration
  stack_create = !local.is_enabled ? {} : {
    stack = local.stack
  }
}
