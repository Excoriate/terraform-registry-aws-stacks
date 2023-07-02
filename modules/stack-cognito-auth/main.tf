// ***************************************
// 1. Create the SES email configuration
// ***************************************
module "auth_ses" {
  for_each   = !local.is_user_pool_email_config_enabled ? {} : local.stack_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-events//modules/ses?ref=v0.1.17"
  aws_region = var.aws_region
  is_enabled = var.is_enabled
  ses_config = {
    name                    = each.value
    domain                  = lookup(var.user_pool_ses_email_config, "domain", null)
    create_domain_mail_from = true
    emails                  = null // If the domain is already validated, then it's not required to create/validate email identities.
  }

  ses_verification_config = {
    name = each.value
  }

  ses_validation_config = {
    name                   = each.value
    enable_dkim_validation = true
  }

  ses_template_config = lookup(var.user_pool_ses_email_config, "email_templates", null) == null ? null : length(lookup(var.user_pool_ses_email_config, "email_templates", [])) == 0 ? null : [for template in lookup(var.user_pool_ses_email_config, "email_templates", []) : {
    name    = template.name
    subject = template.subject
    html    = template.html
    text    = template.text
  }]

  ses_event_destination_config = [
    {
      name           = format("%s-%s", each.value, "bounce-complaint")
      enabled        = true
      matching_types = ["bounce", "complaint"]
      cloudwatch_destination = {
        default_value  = true
        dimension_name = "ses"
        value_source   = "emailHeader"
      }
    },
    {
      name           = each.value // Default one.
      enabled        = true
      matching_types = ["send"]
      cloudwatch_destination = {
        default_value  = true
        dimension_name = "ses"
        value_source   = "emailHeader"
      }
    }
  ]
}

resource "time_sleep" "wait_for_verification" {
  depends_on = [module.auth_ses]

  create_duration = "2m"
}


// ***************************************
// 2. Create Cognito user pool
// ***************************************
module "auth_cognito_user_pool" {
  for_each   = local.stack_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/user-pool?ref=v0.1.17"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  user_pool_config = {
    name                                          = each.value
    user_pool_name                                = format("%s-%s", local.stack, trimspace(var.user_pool_name))
    is_username_case_sensitive                    = var.user_pool_enable_username_case_sensitivity
    alias_attributes                              = var.user_pool_alias_attributes
    deletion_protection_enabled                   = var.user_pool_deletion_protection_enabled
    auto_verified_attributes                      = var.user_pool_auto_verified_attributes
    user_pool_add_ons_security_module             = var.user_pool_add_ons_security_mode
    attributes_require_verification_before_update = var.user_pool_attributes_require_verification_before_update
  }

  email_verification_config = !local.is_user_pool_email_verification_enabled ? null : merge({
    name = each.value
  }, { for k, v in var.user_pool_email_verification_config : k => v == null ? null : v == "" ? null : v })

  sms_verification_config = !local.is_user_pool_sms_verification_enabled ? null : merge({
    name = each.value
  }, { for k, v in var.user_pool_sms_verification_config : k => v == null ? null : v == "" ? null : v })

  mfa_configuration_config = !local.is_user_pool_mfa_configuration_enabled ? null : merge({
    name = each.value
  }, { for k, v in var.user_pool_mfa_configuration_config : k => v == null ? null : v == "" ? null : v })

  admin_create_user_config = !local.is_user_pool_admin_create_user_config_enabled ? null : {
    name                         = each.value
    allow_admin_create_user_only = lookup(var.user_pool_admin_create_user_config, "allow_admin_create_user_only", null)
    invite_message_template      = lookup(var.user_pool_admin_create_user_config, "invite_message_template", null)
  }

  account_recovery_config = !local.is_user_pool_account_recovery_config_enabled ? null : {
    name = each.value
    recovery_mechanisms = [for recovery_mechanism in var.user_pool_account_recovery_config : {
      name     = recovery_mechanism.name
      priority = recovery_mechanism.priority
    }]
  }

  device_configuration = {
    name                                  = each.value
    challenge_required_on_new_device      = var.user_pool_device_challenge_required_on_new_device
    device_only_remembered_on_user_prompt = var.user_pool_device_only_remembered_on_user_prompt
  }

  email_configuration = !local.is_user_pool_email_config_enabled ? null : {
    name                   = each.value
    configuration_set      = each.value
    email_sending_account  = "DEVELOPER"
    from_email_address     = lookup(var.user_pool_ses_email_config, "from_email")
    reply_to_email_address = lookup(var.user_pool_ses_email_config, "reply_to_email")
    source_arn             = join("", [for identity in data.aws_ses_domain_identity.this : identity.arn])
  }

  sms_configuration = !local.is_user_pool_sms_configuration_enabled ? null : merge({
    name = each.value
  }, { for k, v in var.user_pool_sms_configuration : k => v == null ? null : v == "" ? null : v })

  password_policy_config = {
    name                             = each.value
    minimum_length                   = var.user_pool_password_policy_minimum_length
    require_lowercase                = var.user_pool_password_policy_require_lowercase
    require_numbers                  = var.user_pool_password_policy_require_numbers
    require_symbols                  = var.user_pool_password_policy_require_symbols
    require_uppercase                = var.user_pool_password_policy_require_uppercase
    temporary_password_validity_days = var.user_pool_password_policy_temporary_password_validity_days
  }

  schema_attributes_config = !local.is_user_pool_schema_attributes_config_enabled ? null : [
    for s in var.schema_attributes_config : merge(s, { name = each.value })
  ]

  verification_message_template_config = !local.is_user_pool_verification_message_template_config_enabled ? null : [
    for v in var.verification_message_template_config : merge(v, { name = each.value })
  ]

  lambda_config = !local.is_user_pool_lambda_config_enabled ? null : merge(var.lambda_config, { name = each.value })

  tags = local.tags

  depends_on = [
    module.auth_ses,
    time_sleep.wait_for_verification,
    data.aws_ses_domain_identity.this
  ]
}

// ***************************************
// 3. Identity provider
// ***************************************
module "auth_cognito_identity_provider" {
  for_each   = !local.is_identity_provider_config_enabled ? {} : local.stack_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/identity-provider?ref=v0.1.17"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  identity_provider_config = [for idp in var.identity_provider_config : {
    name             = format("%s-%s", each.value, idp.idp_name)
    user_pool_id     = join("", [for user_pool in data.aws_cognito_user_pools.this : user_pool.ids[0]])
    provider_name    = idp.provider_name
    provider_type    = idp.provider_type
    provider_details = idp.provider_details
  }]

  identity_provider_optionals_config = length(local.identity_provider_optionals_config_create) == 0 ? null : local.identity_provider_optionals_config_create

  tags = local.tags
}
