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
  is_user_pool_schema_attributes_config_enabled             = !local.is_enabled ? false : var.user_pool_schema_attributes_config != null
  is_user_pool_verification_message_template_config_enabled = !local.is_enabled ? false : var.user_pool_verification_message_template_config != null
  is_user_pool_lambda_config_enabled                        = !local.is_enabled ? false : var.user_pool_lambda_config != null
  is_identity_provider_config_enabled                       = !local.is_enabled ? false : var.identity_provider_config != null

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

  // Amendment for the identity_provider_optionals_config
  identity_provider_optionals_config = !local.is_identity_provider_config_enabled ? null : [for idp in var.identity_provider_config : {
    name              = trimspace(idp["idp_name"])
    idp_identifiers   = idp["idp_identifiers"]
    attribute_mapping = idp["attribute_mapping"]
    is_set            = idp["attribute_mapping"] != null && idp["idp_identifiers"] != null
  }]

  identity_provider_optionals_config_create = !local.is_identity_provider_config_enabled ? null : [for idp in local.identity_provider_optionals_config : idp if idp["is_set"] == true]
}
