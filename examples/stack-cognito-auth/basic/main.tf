module "main_module" {
  source     = "../../../modules/stack-cognito-auth"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  stack = var.stack
  // Cognito user pool
  user_pool_name                                             = "my-pool"
  user_pool_alias_attributes                                 = var.user_pool_alias_attributes
  user_pool_deletion_protection_enabled                      = var.user_pool_deletion_protection_enabled
  user_pool_auto_verified_attributes                         = var.user_pool_auto_verified_attributes
  user_pool_add_ons_security_mode                            = var.user_pool_add_ons_security_mode
  user_pool_attributes_require_verification_before_update    = var.user_pool_attributes_require_verification_before_update
  user_pool_email_verification_config                        = var.user_pool_email_verification_config
  user_pool_sms_verification_config                          = var.user_pool_sms_verification_config
  user_pool_mfa_configuration_config                         = var.user_pool_mfa_configuration_config
  user_pool_admin_create_user_config                         = var.user_pool_admin_create_user_config
  user_pool_account_recovery_config                          = var.user_pool_account_recovery_config
  user_pool_device_only_remembered_on_user_prompt            = var.user_pool_device_only_remembered_on_user_prompt
  user_pool_device_challenge_required_on_new_device          = var.user_pool_device_challenge_required_on_new_device
  user_pool_ses_email_config                                 = var.user_pool_ses_email_config
  user_pool_sms_configuration                                = var.user_pool_sms_configuration
  user_pool_password_policy_minimum_length                   = var.user_pool_password_policy_minimum_length
  user_pool_password_policy_require_lowercase                = var.user_pool_password_policy_require_lowercase
  user_pool_password_policy_require_uppercase                = var.user_pool_password_policy_require_uppercase
  user_pool_password_policy_require_numbers                  = var.user_pool_password_policy_require_numbers
  user_pool_password_policy_require_symbols                  = var.user_pool_password_policy_require_symbols
  user_pool_password_policy_temporary_password_validity_days = var.user_pool_password_policy_temporary_password_validity_days
  user_pool_schema_attributes_config                         = var.user_pool_schema_attributes_config
  user_pool_verification_message_template_config             = var.user_pool_verification_message_template_config
  user_pool_lambda_config                                    = var.user_pool_lambda_config
  user_pool_domain_config                                    = var.user_pool_domain_config

  // Identity provider.
  identity_provider_config = var.identity_provider_config

  // Cognito user pool client
  user_pool_clients_config = var.user_pool_clients_config

}
