variable "is_enabled" {
  type        = bool
  description = <<EOF
  Whether this module will be created or not. It is useful, for stack-composite
modules that conditionally includes resources provided by this module..
EOF
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/
variable "stack" {
  type        = string
  description = <<EOF
Name of the stack. If the option var.enable_stack_prefix is explicitly
set to false, the 'stack' will be used to manage internally 'terraform' logic
but it will not be used as prefix for the resources created by this module.
EOF
}

variable "enable_stack_prefix" {
  type        = bool
  description = <<EOF
Whether to use the 'stack' variable as prefix for the resources created by
this module. If set to false, the 'stack' variable will be used to manage
internally 'terraform' logic but it will not be used as prefix for the
resources created by this module.
EOF
  default     = true
}

/*
-------------------------------------
Cognito User Pool
------------------------------------
*/
variable "user_pool_name" {
  type        = string
  description = "The name of the user pool."
}

variable "user_pool_enable_username_case_sensitivity" {
  type        = bool
  description = "Specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs."
  default     = true
}

variable "user_pool_alias_attributes" {
  type        = list(string)
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username."
  default     = ["email"]
}

variable "user_pool_deletion_protection_enabled" {
  type        = bool
  description = "Specifies whether a user pool deletion protection is enabled or not."
  default     = false
}

variable "user_pool_auto_verified_attributes" {
  type        = list(string)
  description = "The attributes to be auto-verified. Possible values: email, phone_number."
  default     = ["email"]
}

variable "user_pool_add_ons_security_mode" {
  type        = string
  description = "The mode for advanced security, must be one of OFF, AUDIT or ENFORCED."
  default     = null
}

variable "user_pool_attributes_require_verification_before_update" {
  type        = list(string)
  description = "Attributes that are automatically verified when the Amazon Cognito service makes an API call to update user pools."
  default     = null
}

variable "user_pool_email_verification_config" {
  type = object({
    email_verification_subject = string
    email_verification_message = string
  })
  description = <<EOF
  List of email verification configurations to create. These attributes are used in order
to set the email verification message that is sent to the user when they sign up.
EOF
  default     = null
}

variable "user_pool_sms_verification_config" {
  type = object({
    sms_verification_message   = string
    sms_authentication_message = string
  })
  description = <<EOF
  List of SMS verification configurations to create. These attributes are used in order
to set the SMS verification message that is sent to the user when they sign up.
EOF
  default     = null
}

variable "user_pool_mfa_configuration_config" {
  type = object({
    enable_mfa               = optional(bool, false)
    disable_mfa              = optional(bool, true) // set by default
    enable_optional_mfa      = optional(bool, false)
    allow_software_mfa_token = optional(bool, false)
  })
  description = <<EOF
  List of MFA configurations to create. The options are:
  - enable_mfa: Enable MFA for all users.
  - disable_mfa: Disable MFA for all users.
  - enable_optional_mfa: Enable MFA for all users, but allow them to choose not to use it.
By default, it's set to 'disable_mfa'.
EOF
  default = {
    enable_mfa               = false
    disable_mfa              = true
    enable_optional_mfa      = false
    allow_software_mfa_token = false
  }
}

variable "user_pool_admin_create_user_config" {
  type = object({
    allow_admin_create_user_only = optional(bool, false)
    invite_message_template = optional(object({
      email_message = optional(string, null)
      email_subject = optional(string, null)
      sms_message   = optional(string, null)
    }), null)
  })
  description = <<EOF
  List of admin create user configurations to create. These attributes are used in order
to set the admin create user message that is sent to the user when they sign up.
EOF
  default     = null
}

variable "user_pool_account_recovery_config" {
  type = list(object({
    name     = string
    priority = number
  }))
  description = <<EOF
  List of account recovery configurations to create. These attributes are used in order
to set the account recovery message that is sent to the user when they sign up.
EOF
  default     = null
}

variable "user_pool_device_only_remembered_on_user_prompt" {
  type        = bool
  description = "Indicates whether a challenge is required on a new device. Only applicable to a new device."
  default     = false
}

variable "user_pool_device_challenge_required_on_new_device" {
  type        = bool
  description = "If true, a device is only remembered on user prompt."
  default     = false
}

variable "user_pool_ses_email_config" {
  type = object({
    domain         = string
    from_email     = string
    reply_to_email = string
    email_templates = optional(list(object({
      name    = string
      subject = string
      html    = string
      text    = string
    })), [])
  })
  description = <<EOF
  List of SES email configurations to create. These attributes are used in order
to set the SES email message that is sent to the user when they sign up.
EOF
  default     = null
}

variable "user_pool_sms_configuration" {
  type = object({
    external_id    = optional(string, null)
    sns_caller_arn = optional(string, null)
    sns_region     = optional(string, "us-east-1")
  })
  description = <<EOF
The SMS configuration to create. These attributes are used in order
to set the SMS configuration that is available to the user when they sign up.
For more information about this specific attribute please refer to the following link:
https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-sms-configuration.html
EOF
  default     = null
}

variable "user_pool_password_policy_minimum_length" {
  type        = number
  description = "The minimum length of the password policy that you have set."
  default     = 8
}

variable "user_pool_password_policy_require_lowercase" {
  type        = bool
  description = "Specifies whether at least one lowercase character is required in the password."
  default     = true
}

variable "user_pool_password_policy_require_uppercase" {
  type        = bool
  description = "Specifies whether at least one uppercase character is required in the password."
  default     = true
}

variable "user_pool_password_policy_require_numbers" {
  type        = bool
  description = "Specifies whether at least one number is required in the password."
  default     = true
}

variable "user_pool_password_policy_require_symbols" {
  type        = bool
  description = "Specifies whether at least one symbol is required in the password."
  default     = true
}

variable "user_pool_password_policy_temporary_password_validity_days" {
  type        = number
  description = "The user account expiration limit, in days, after which the account is no longer usable."
  default     = 7
}

variable "schema_attributes_config" {
  type = list(object({
    attribute_name           = string
    attribute_data_type      = string
    developer_only_attribute = optional(bool, false)
    mutable                  = optional(bool, true)
    required                 = optional(bool, false)
    string_attribute_constraints = optional(object({
      max_length = optional(string, null)
      min_length = optional(string, null)
    }), null)
    number_attribute_constraints = optional(object({
      max_value = optional(string, null)
      min_value = optional(string, null)
    }), null)
  }))
  description = <<EOF
The schema attributes configuration to create. These attributes are used in order
to set the schema attributes configuration that is available to the user when they sign up.
For more information about this specific attribute please refer to the following link:
https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
EOF
  default     = null
}

variable "verification_message_template_config" {
  type = object({
    default_email_option  = optional(string, null)
    email_message_by_link = optional(string, null)
    email_message         = optional(string, null)
    email_subject         = optional(string, null)
    email_subject_by_link = optional(string, null)
    sms_message           = optional(string, null)
  })
  description = <<EOF
The verification message template configuration to create. These attributes are used in order
to set the verification message template configuration that is available to the user when they sign up.
For more information about this specific attribute please refer to the following link:
https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-email.html
EOF
  default     = null
}

variable "lambda_config" {
  type = object({
    create_auth_challenge          = optional(string, null)
    custom_message                 = optional(string, null)
    define_auth_challenge          = optional(string, null)
    post_authentication            = optional(string, null)
    post_confirmation              = optional(string, null)
    pre_authentication             = optional(string, null)
    pre_sign_up                    = optional(string, null)
    pre_token_generation           = optional(string, null)
    user_migration                 = optional(string, null)
    verify_auth_challenge_response = optional(string, null)
    kms_key_id                     = optional(string, null)
    custom_email_sender = optional(object({
      lambda_arn     = optional(string, null)
      lambda_version = optional(string, null)
    }), null)
    custom_sms_sender = optional(object({
      lambda_arn     = optional(string, null)
      lambda_version = optional(string, null)
    }), null)
  })
  description = <<EOF
The lambda configuration to create. These attributes are used in order
to set the lambda configuration that is available to the user when they sign up.
For more information about this specific attribute please refer to the following link:
https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-lambda.html
EOF
  default     = null
}

variable "identity_provider_config" {
  type = list(object({
    idp_name          = string
    provider_name     = string
    provider_type     = string
    provider_details  = map(string)
    attribute_mapping = optional(map(string), null)
    idp_identifiers   = optional(list(string), null)
  }))
  description = <<EOF
  List of identity provider configurations to create. The required arguments are described in the
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_identity_provider
These are:
  - name: Friendly identifier for the terraform resource to be created.
  - user_pool_id: The user pool ID.
  - provider_name: The identity provider name. It can be a string with the following values: "Facebook", "Google",
    "LoginWithAmazon", "SignInWithApple", "OIDC", "SAML".
  - provider_type: The identity provider type. It refers to the type of third party identity provider.
    "SAML" for SAML providers, "Facebook" for Facebook login, "Google" for Google login, and "LoginWithAmazon" for
    Login with Amazon.
  - provider_details: The identity provider details, such as MetadataURL and MetadataFile.
  - attribute_mapping: A mapping of identity provider attributes to standard and custom user pool attributes.
  - idp_identifiers: A list of identity provider identifiers.
EOF
  default     = null
}
