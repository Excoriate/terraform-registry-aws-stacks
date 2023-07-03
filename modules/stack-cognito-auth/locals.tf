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
  is_user_pool_clients_config_enabled                       = !local.is_enabled ? false : var.user_pool_clients_config == null ? false : length(var.user_pool_clients_config) > 0
  is_user_pool_domain_config_enabled                        = !local.is_enabled ? false : var.user_pool_domain_config != null

  // Naming convention
  stack = !local.is_enabled ? null : lower(trimspace(var.stack))

  tags = local.is_enabled ? merge(
    {
      "Stack" = local.stack
    },
    var.tags,
  ) : {}

  // User pool configuration
  stack_create = !local.is_enabled ? {} : {
    stack = format("stack-%s", local.stack)
  }

  // Amendment for the identity_provider_optionals_config
  identity_provider_optionals_config = !local.is_identity_provider_config_enabled ? null : [for idp in var.identity_provider_config : {
    name              = trimspace(idp["idp_name"])
    idp_identifiers   = idp["idp_identifiers"]
    attribute_mapping = idp["attribute_mapping"]
    is_set            = idp["attribute_mapping"] != null && idp["idp_identifiers"] != null
  }]

  identity_provider_optionals_config_create = !local.is_identity_provider_config_enabled ? null : [for idp in local.identity_provider_optionals_config : idp if idp["is_set"] == true]

  ##############################################
  # USER POOL CLIENT
  ##############################################
  // 1. Main configuration object.
  user_pools_client_config_normalised = !local.is_user_pool_clients_config_enabled ? null : [
    for c in var.user_pool_clients_config : {
      name         = format("%s-%s", local.stack, trimspace(c["client_name"]))
      user_pool_id = join("", [for user_pool in data.aws_cognito_user_pools.this : user_pool.ids[0]])
    }
  ]

  // 2. OAuth configuration
  user_pools_client_oauth_config_normalised = !local.is_user_pool_clients_config_enabled ? null : [
    for c in var.user_pool_clients_config : {
      name                                 = format("%s-%s", local.stack, trimspace(c["client_name"]))
      allowed_oauth_flows_user_pool_client = c["allowed_oauth_flows_user_pool_client"]
      allowed_oauth_flows                  = c["allowed_oauth_flows"]
      allowed_oauth_scopes                 = c["allowed_oauth_scopes"]
      callback_urls                        = [for url in c["callback_urls"] : trimspace(url)]
    }
  ]

  // 3. Token config.
  user_pools_client_token_config_normalised = !local.is_user_pool_clients_config_enabled ? null : [
    for c in var.user_pool_clients_config : {
      name                    = format("%s-%s", local.stack, trimspace(c["client_name"]))
      id_token_validity       = c["id_token_validity"]
      access_token_validity   = c["access_token_validity"]
      refresh_token_validity  = c["refresh_token_validity"]
      enable_token_revocation = c["enable_token_revocation"]
      token_validity_units    = c["token_validity_units"]
    }
  ]

  // 4. Others/Advanced configurations.
  user_pools_client_advanced_config_normalised = !local.is_user_pool_clients_config_enabled ? null : [
    for c in var.user_pool_clients_config : {
      name                          = format("%s-%s", local.stack, trimspace(c["client_name"]))
      auth_session_validity         = c["auth_session_validity"]
      default_redirect_uri          = c["default_redirect_uri"]
      explicit_auth_flows           = c["explicit_auth_flows"]
      generate_secret               = c["generate_secret"]
      logout_urls                   = [for url in c["logout_urls"] : trimspace(url)]
      read_attributes               = c["read_attributes"]
      supported_identity_providers  = c["supported_identity_providers"]
      prevent_user_existence_errors = c["prevent_user_existence_errors"]
      write_attributes              = c["write_attributes"]
    }
  ]
}
