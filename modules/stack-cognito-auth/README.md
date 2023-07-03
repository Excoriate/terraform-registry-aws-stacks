<!-- BEGIN_TF_DOCS -->
# ☁️ AWS Auth Stack (SES/Cognito "battery included" 🔋 stack)
## Description

This composite stack module provisions AWS Cognito and SES services, implementing all supported capabilities of the following open-source Terraform modules:

- [AWS SES Terraform module](https://github.com/Excoriate/terraform-registry-aws-events/tree/main/modules/ses):
* 🚀 Provision SES service.
* 🚀 Support for Email Sending/Receiving.
* 🚀 Configure Mail from domain.
* 🚀 Manage Email Verifications.
Refer to the [official AWS SES documentation](https://docs.aws.amazon.com/ses/latest/dg/Welcome.html) for more details on AWS SES.

- [AWS Cognito Terraform module](https://github.com/Excoriate/terraform-registry-aws-events/tree/main/modules/cognito):
* 🚀 Provision Cognito User Pool.
* 🚀 Support for Identity Providers and User Pool Clients.
* 🚀 Manage User Pool Domains and other resources.
Refer to the [official AWS Cognito documentation](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html) for more details on AWS Cognito.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
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
```

```
A simple implementation can be found here:
```hcl
aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

```

A more advanced one:
```hcl
aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

user_pool_ses_email_config = {
  domain         = "4id.network"
  from_email     = "tsn_test@4id.network"
  reply_to_email = "tsn_test@4id.network"
}

user_pool_mfa_configuration_config = {
  enable_mfa  = false
  disable_mfa = false
}

user_pool_account_recovery_config = null

identity_provider_config = [
  {
    idp_name      = "LoginWithAmazon",
    provider_name = "LoginWithAmazon"
    provider_type = "LoginWithAmazon"
    provider_details = {
      client_id        = "client_id"
      client_secret    = "client_secret"
      authorize_scopes = "email, profile, openid" # Added authorize_scopes
    }
    idp_identifiers = ["login.amazon.com"]
    attribute_mapping = {
      email = "email"
      name  = "name"
    }
  },
  #  {
  #    idp_name      = "SignInWithApple",
  #    provider_name = "SignInWithApple"
  #    provider_type = "SignInWithApple"
  #    provider_details = {
  #      client_id        = "client_id"
  #      team_id          = "team_id"
  #      key_id           = "key_id"
  #      "private_key"   = "-----BEGIN PRIVATE KEY-----\nYOUR_FAKE_PRIVATE_KEY\n-----END PRIVATE KEY-----"
  #      authorize_scopes = "email,name"
  #    }
  #    idp_identifiers = ["appleid.apple.com"]
  #    attribute_mapping = {
  #      email = "email"
  #      name  = "name"
  #    }
  #  },
  {
    idp_name      = "Facebook",
    provider_name = "Google"
    provider_type = "Google"
    provider_details = {
      client_id        = "client_id"
      client_secret    = "client_secret"
      authorize_scopes = "email, profile, openid" # Added authorize_scopes
    }
    idp_identifiers = ["accounts.google.com"]
    attribute_mapping = {
      email = "email"
      name  = "name"
    }
  }
]

user_pool_clients_config = [
  {
    client_name                          = "client-app-1"
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows                  = ["code"]
    allowed_oauth_scopes                 = ["email", "openid"]
    callback_urls                        = ["https://app1.example.com/login", "https://app1.example.com/landing"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = null
    enable_token_revocation              = true
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = null
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app1.example.com/landing"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH"]
    generate_secret               = false
    logout_urls                   = ["https://app1.example.com/logout"]
    read_attributes               = ["email"]
    supported_identity_providers  = ["COGNITO"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["email"]
  },
  {
    client_name                          = "client-app-2"
    allowed_oauth_flows_user_pool_client = false
    allowed_oauth_flows                  = ["implicit"]
    allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
    callback_urls                        = ["https://app2.example.com/login", "https://app2.example.com/dashboard"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = 2
    enable_token_revocation              = false
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = "days"
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app2.example.com/dashboard"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH", "CUSTOM_AUTH_FLOW_ONLY"]
    generate_secret               = false
    logout_urls                   = ["https://app2.example.com/logout"]
    read_attributes               = ["email"]
    supported_identity_providers  = ["Google"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["phone_number"]
  },
  {
    client_name                          = "client-app-3"
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows                  = ["code", "implicit"]
    allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin"]
    callback_urls                        = ["https://app3.example.com/login", "https://app3.example.com/dashboard"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = null
    enable_token_revocation              = true
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = null
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app3.example.com/dashboard"
    explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH"]
    generate_secret               = true
    logout_urls                   = ["https://app3.example.com/logout"]
    read_attributes               = ["email", "name"],
    supported_identity_providers  = ["Google"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["email", "name"]
  }
]

```

With all-included Email (SES) configuration
```hcl
aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

user_pool_ses_email_config = {
  domain         = "4id.network"
  from_email     = "tsn_test@4id.network"
  reply_to_email = "tsn_test@4id.network"
}

```

For module composition, It's recommended to take a look at the module's `outputs` to understand what's available:
```hcl
output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = local.aws_region_to_deploy
  description = "The AWS region where the module is deployed."
}

output "tags_set" {
  value       = var.tags
  description = "The tags set for the module."
}

output "cognito_user_pool" {
  value       = module.auth_cognito_user_pool
  description = "The Cognito User Pool."
}

output "cognito_user_pool_client" {
  value       = module.auth_cognito_user_pool_clients
  description = "The Cognito User Pool Client."
}

output "cognito_identity_provider" {
  value       = module.auth_cognito_identity_provider
  description = "The Cognito Identity Provider."
}

output "cognito_user_pool_domain" {
  value       = module.auth_cognito_user_pool_domain
  description = "The Cognito User Pool Domain."
}

output "email_configuration" {
  value       = module.auth_ses
  description = "The Cognito Email Configuration supported by SES."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_auth_cognito_identity_provider"></a> [auth\_cognito\_identity\_provider](#module\_auth\_cognito\_identity\_provider) | git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/identity-provider | v0.1.17 |
| <a name="module_auth_cognito_user_pool"></a> [auth\_cognito\_user\_pool](#module\_auth\_cognito\_user\_pool) | git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/user-pool | v0.1.17 |
| <a name="module_auth_cognito_user_pool_clients"></a> [auth\_cognito\_user\_pool\_clients](#module\_auth\_cognito\_user\_pool\_clients) | git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/user-pool-client | v0.1.17 |
| <a name="module_auth_cognito_user_pool_domain"></a> [auth\_cognito\_user\_pool\_domain](#module\_auth\_cognito\_user\_pool\_domain) | git::github.com/Excoriate/terraform-registry-aws-events//modules/cognito/user-pool-domain | v0.1.17 |
| <a name="module_auth_ses"></a> [auth\_ses](#module\_auth\_ses) | git::github.com/Excoriate/terraform-registry-aws-events//modules/ses | v0.1.17 |

## Resources

| Name | Type |
|------|------|
| [time_sleep.wait_for_verification](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_cognito_user_pools.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cognito_user_pools) | data source |
| [aws_ses_domain_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ses_domain_identity) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.1, < 0.8.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_identity_provider_config"></a> [identity\_provider\_config](#input\_identity\_provider\_config) | List of identity provider configurations to create. The required arguments are described in the<br>  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_identity_provider<br>These are:<br>  - name: Friendly identifier for the terraform resource to be created.<br>  - user\_pool\_id: The user pool ID.<br>  - provider\_name: The identity provider name. It can be a string with the following values: "Facebook", "Google",<br>    "LoginWithAmazon", "SignInWithApple", "OIDC", "SAML".<br>  - provider\_type: The identity provider type. It refers to the type of third party identity provider.<br>    "SAML" for SAML providers, "Facebook" for Facebook login, "Google" for Google login, and "LoginWithAmazon" for<br>    Login with Amazon.<br>  - provider\_details: The identity provider details, such as MetadataURL and MetadataFile.<br>  - attribute\_mapping: A mapping of identity provider attributes to standard and custom user pool attributes.<br>  - idp\_identifiers: A list of identity provider identifiers. | <pre>list(object({<br>    idp_name          = string<br>    provider_name     = string<br>    provider_type     = string<br>    provider_details  = map(string)<br>    attribute_mapping = optional(map(string), null)<br>    idp_identifiers   = optional(list(string), null)<br>  }))</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Name of the stack. If the option var.enable\_stack\_prefix is explicitly<br>set to false, the 'stack' will be used to manage internally 'terraform' logic<br>but it will not be used as prefix for the resources created by this module. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_user_pool_account_recovery_config"></a> [user\_pool\_account\_recovery\_config](#input\_user\_pool\_account\_recovery\_config) | List of account recovery configurations to create. These attributes are used in order<br>to set the account recovery message that is sent to the user when they sign up. | <pre>list(object({<br>    name     = string<br>    priority = number<br>  }))</pre> | <pre>[<br>  {<br>    "name": "verified_email",<br>    "priority": 1<br>  },<br>  {<br>    "name": "verified_phone_number",<br>    "priority": 2<br>  }<br>]</pre> | no |
| <a name="input_user_pool_add_ons_security_mode"></a> [user\_pool\_add\_ons\_security\_mode](#input\_user\_pool\_add\_ons\_security\_mode) | The mode for advanced security, must be one of OFF, AUDIT or ENFORCED. | `string` | `null` | no |
| <a name="input_user_pool_admin_create_user_config"></a> [user\_pool\_admin\_create\_user\_config](#input\_user\_pool\_admin\_create\_user\_config) | List of admin create user configurations to create. These attributes are used in order<br>to set the admin create user message that is sent to the user when they sign up. | <pre>object({<br>    allow_admin_create_user_only = optional(bool, false)<br>    invite_message_template = optional(object({<br>      email_message = optional(string, null)<br>      email_subject = optional(string, null)<br>      sms_message   = optional(string, null)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_user_pool_alias_attributes"></a> [user\_pool\_alias\_attributes](#input\_user\_pool\_alias\_attributes) | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. | `list(string)` | <pre>[<br>  "email"<br>]</pre> | no |
| <a name="input_user_pool_attributes_require_verification_before_update"></a> [user\_pool\_attributes\_require\_verification\_before\_update](#input\_user\_pool\_attributes\_require\_verification\_before\_update) | Attributes that are automatically verified when the Amazon Cognito service makes an API call to update user pools. | `list(string)` | `null` | no |
| <a name="input_user_pool_auto_verified_attributes"></a> [user\_pool\_auto\_verified\_attributes](#input\_user\_pool\_auto\_verified\_attributes) | The attributes to be auto-verified. Possible values: email, phone\_number. | `list(string)` | <pre>[<br>  "email"<br>]</pre> | no |
| <a name="input_user_pool_clients_config"></a> [user\_pool\_clients\_config](#input\_user\_pool\_clients\_config) | List of user pool client configurations to create. The required arguments are described in the AWS provider documentation:<br>  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client<br><br>   These are:<br>     - name: Friendly identifier for the Terraform resource to be created.<br>     - user\_pool\_id: The user pool ID.<br>     - client\_name: Client friendly name.<br>     - callback\_urls: List of URLs for the callback signing in.<br>     - default\_redirect\_uri: Must be listed in the CallbackURLs.<br>     - logout\_urls: List of URLs for signing out.<br><br>   Note: To enhance security measures, avoid passing sensitive data as inline text or hardcoding. Instead, consider using environment variables or encrypted data using key management services. | <pre>list(object({<br>    client_name                          = string<br>    allowed_oauth_flows_user_pool_client = optional(bool, true)                         // Indicates whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools.<br>    allowed_oauth_flows                  = optional(list(string), ["code", "implicit"]) // Grant types ["code", "implicit", "client_credentials"] allowed with this user pool client.<br>    allowed_oauth_scopes = optional(list(string), [<br>      "phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"<br>    ])<br>    // The type of Amazon Cognito resources that can be accessed with the OAuth scopes provided.<br>    callback_urls           = list(string)           // List of allowed redirect (signin) URLs for the Identity providers.<br>    id_token_validity       = optional(number, 1)    // The time limit in days after which an ID token is no longer valid and with which a user must log back into your client app, the default is 30 days.<br>    access_token_validity   = optional(number, 1)    // The time limit in days after which an access token is no longer valid and with which a user must be asked to log back into your client app, the default is 60 days.<br>    refresh_token_validity  = optional(number, null) // The time limit in days after which a refresh token is no longer valid and with which a user must log back into your client app, the default is 30 days.<br>    enable_token_revocation = optional(bool, false)  // Whether to revoke userpool application client tokens upon token expiration.<br>    token_validity_units = optional(object({<br>      id_token      = optional(string, "days")<br>      access_token  = optional(string, "days")<br>      refresh_token = optional(string, null)<br>    }), null)<br>    auth_session_validity         = optional(number, null) // The time limit in days for the refresh token within an AWS AppStream streaming URL, the default is 1 day.<br>    default_redirect_uri          = string                 // The default URL where we redirect the user after they sign in.<br>    explicit_auth_flows           = optional(list(string), ["ADMIN_NO_SRP_AUTH", "CUSTOM_AUTH_FLOW_ONLY", "USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"])<br>    generate_secret               = optional(bool, false)                                            // Should the app client secret be generated? As a security measure, this should be set to true for web application type clients.<br>    logout_urls                   = list(string)                                                     // List of allowed logout URLs for the Identity providers.<br>    read_attributes               = optional(list(string), null)                                     // List of read attributes for the user pool.<br>    supported_identity_providers  = optional(list(string), ["COGNITO", "Google", "SignInWithApple"]) // List of provider types for the Identity providers to connect with.<br>    prevent_user_existence_errors = optional(string, "ENABLED")                                      // Choose settings that can help prevent your app from revealing information about your users' accounts.<br>    write_attributes              = optional(list(string), null)                                     // List of write attributes for the user pool.<br>  }))</pre> | `null` | no |
| <a name="input_user_pool_deletion_protection_enabled"></a> [user\_pool\_deletion\_protection\_enabled](#input\_user\_pool\_deletion\_protection\_enabled) | Specifies whether a user pool deletion protection is enabled or not. | `bool` | `false` | no |
| <a name="input_user_pool_device_challenge_required_on_new_device"></a> [user\_pool\_device\_challenge\_required\_on\_new\_device](#input\_user\_pool\_device\_challenge\_required\_on\_new\_device) | If true, a device is only remembered on user prompt. | `bool` | `false` | no |
| <a name="input_user_pool_device_only_remembered_on_user_prompt"></a> [user\_pool\_device\_only\_remembered\_on\_user\_prompt](#input\_user\_pool\_device\_only\_remembered\_on\_user\_prompt) | Indicates whether a challenge is required on a new device. Only applicable to a new device. | `bool` | `false` | no |
| <a name="input_user_pool_domain_config"></a> [user\_pool\_domain\_config](#input\_user\_pool\_domain\_config) | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain name.<br>  Required if you specify a custom domain name for your user pool.<br>  Otherwise, this property can be omitted. | <pre>object({<br>    certificate_arn = optional(string, null)<br>    domain          = string<br>  })</pre> | `null` | no |
| <a name="input_user_pool_email_verification_config"></a> [user\_pool\_email\_verification\_config](#input\_user\_pool\_email\_verification\_config) | List of email verification configurations to create. These attributes are used in order<br>to set the email verification message that is sent to the user when they sign up. | <pre>object({<br>    email_verification_subject = string<br>    email_verification_message = string<br>  })</pre> | `null` | no |
| <a name="input_user_pool_enable_username_case_sensitivity"></a> [user\_pool\_enable\_username\_case\_sensitivity](#input\_user\_pool\_enable\_username\_case\_sensitivity) | Specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs. | `bool` | `true` | no |
| <a name="input_user_pool_lambda_config"></a> [user\_pool\_lambda\_config](#input\_user\_pool\_lambda\_config) | The lambda configuration to create. These attributes are used in order<br>to set the lambda configuration that is available to the user when they sign up.<br>For more information about this specific attribute please refer to the following link:<br>https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-lambda.html | <pre>object({<br>    create_auth_challenge          = optional(string, null)<br>    custom_message                 = optional(string, null)<br>    define_auth_challenge          = optional(string, null)<br>    post_authentication            = optional(string, null)<br>    post_confirmation              = optional(string, null)<br>    pre_authentication             = optional(string, null)<br>    pre_sign_up                    = optional(string, null)<br>    pre_token_generation           = optional(string, null)<br>    user_migration                 = optional(string, null)<br>    verify_auth_challenge_response = optional(string, null)<br>    kms_key_id                     = optional(string, null)<br>    custom_email_sender = optional(object({<br>      lambda_arn     = optional(string, null)<br>      lambda_version = optional(string, null)<br>    }), null)<br>    custom_sms_sender = optional(object({<br>      lambda_arn     = optional(string, null)<br>      lambda_version = optional(string, null)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_user_pool_mfa_configuration_config"></a> [user\_pool\_mfa\_configuration\_config](#input\_user\_pool\_mfa\_configuration\_config) | List of MFA configurations to create. The options are:<br>  - enable\_mfa: Enable MFA for all users.<br>  - disable\_mfa: Disable MFA for all users.<br>  - enable\_optional\_mfa: Enable MFA for all users, but allow them to choose not to use it.<br>By default, it's set to 'disable\_mfa'. | <pre>object({<br>    enable_mfa               = optional(bool, true)<br>    disable_mfa              = optional(bool, false) // set by default<br>    enable_optional_mfa      = optional(bool, false)<br>    allow_software_mfa_token = optional(bool, false)<br>  })</pre> | <pre>{<br>  "allow_software_mfa_token": false,<br>  "disable_mfa": true,<br>  "enable_mfa": false,<br>  "enable_optional_mfa": false<br>}</pre> | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | The name of the user pool. | `string` | n/a | yes |
| <a name="input_user_pool_password_policy_minimum_length"></a> [user\_pool\_password\_policy\_minimum\_length](#input\_user\_pool\_password\_policy\_minimum\_length) | The minimum length of the password policy that you have set. | `number` | `8` | no |
| <a name="input_user_pool_password_policy_require_lowercase"></a> [user\_pool\_password\_policy\_require\_lowercase](#input\_user\_pool\_password\_policy\_require\_lowercase) | Specifies whether at least one lowercase character is required in the password. | `bool` | `true` | no |
| <a name="input_user_pool_password_policy_require_numbers"></a> [user\_pool\_password\_policy\_require\_numbers](#input\_user\_pool\_password\_policy\_require\_numbers) | Specifies whether at least one number is required in the password. | `bool` | `true` | no |
| <a name="input_user_pool_password_policy_require_symbols"></a> [user\_pool\_password\_policy\_require\_symbols](#input\_user\_pool\_password\_policy\_require\_symbols) | Specifies whether at least one symbol is required in the password. | `bool` | `true` | no |
| <a name="input_user_pool_password_policy_require_uppercase"></a> [user\_pool\_password\_policy\_require\_uppercase](#input\_user\_pool\_password\_policy\_require\_uppercase) | Specifies whether at least one uppercase character is required in the password. | `bool` | `true` | no |
| <a name="input_user_pool_password_policy_temporary_password_validity_days"></a> [user\_pool\_password\_policy\_temporary\_password\_validity\_days](#input\_user\_pool\_password\_policy\_temporary\_password\_validity\_days) | The user account expiration limit, in days, after which the account is no longer usable. | `number` | `7` | no |
| <a name="input_user_pool_schema_attributes_config"></a> [user\_pool\_schema\_attributes\_config](#input\_user\_pool\_schema\_attributes\_config) | The schema attributes configuration to create. These attributes are used in order<br>to set the schema attributes configuration that is available to the user when they sign up.<br>For more information about this specific attribute please refer to the following link:<br>https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html | <pre>list(object({<br>    attribute_name           = string<br>    attribute_data_type      = string<br>    developer_only_attribute = optional(bool, false)<br>    mutable                  = optional(bool, true)<br>    required                 = optional(bool, false)<br>    string_attribute_constraints = optional(object({<br>      max_length = optional(string, null)<br>      min_length = optional(string, null)<br>    }), null)<br>    number_attribute_constraints = optional(object({<br>      max_value = optional(string, null)<br>      min_value = optional(string, null)<br>    }), null)<br>  }))</pre> | `null` | no |
| <a name="input_user_pool_ses_email_config"></a> [user\_pool\_ses\_email\_config](#input\_user\_pool\_ses\_email\_config) | List of SES email configurations to create. These attributes are used in order<br>to set the SES email message that is sent to the user when they sign up. | <pre>object({<br>    domain         = string<br>    from_email     = string<br>    reply_to_email = string<br>    email_templates = optional(list(object({<br>      name    = string<br>      subject = string<br>      html    = string<br>      text    = string<br>    })), [])<br>  })</pre> | `null` | no |
| <a name="input_user_pool_sms_configuration"></a> [user\_pool\_sms\_configuration](#input\_user\_pool\_sms\_configuration) | The SMS configuration to create. These attributes are used in order<br>to set the SMS configuration that is available to the user when they sign up.<br>For more information about this specific attribute please refer to the following link:<br>https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-sms-configuration.html | <pre>object({<br>    external_id    = optional(string, null)<br>    sns_caller_arn = optional(string, null)<br>    sns_region     = optional(string, "us-east-1")<br>  })</pre> | `null` | no |
| <a name="input_user_pool_sms_verification_config"></a> [user\_pool\_sms\_verification\_config](#input\_user\_pool\_sms\_verification\_config) | List of SMS verification configurations to create. These attributes are used in order<br>to set the SMS verification message that is sent to the user when they sign up. | <pre>object({<br>    sms_verification_message   = string<br>    sms_authentication_message = string<br>  })</pre> | `null` | no |
| <a name="input_user_pool_verification_message_template_config"></a> [user\_pool\_verification\_message\_template\_config](#input\_user\_pool\_verification\_message\_template\_config) | The verification message template configuration to create. These attributes are used in order<br>to set the verification message template configuration that is available to the user when they sign up.<br>For more information about this specific attribute please refer to the following link:<br>https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-email.html | <pre>object({<br>    default_email_option  = optional(string, null)<br>    email_message_by_link = optional(string, null)<br>    email_message         = optional(string, null)<br>    email_subject         = optional(string, null)<br>    email_subject_by_link = optional(string, null)<br>    sms_message           = optional(string, null)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_cognito_identity_provider"></a> [cognito\_identity\_provider](#output\_cognito\_identity\_provider) | The Cognito Identity Provider. |
| <a name="output_cognito_user_pool"></a> [cognito\_user\_pool](#output\_cognito\_user\_pool) | The Cognito User Pool. |
| <a name="output_cognito_user_pool_client"></a> [cognito\_user\_pool\_client](#output\_cognito\_user\_pool\_client) | The Cognito User Pool Client. |
| <a name="output_cognito_user_pool_domain"></a> [cognito\_user\_pool\_domain](#output\_cognito\_user\_pool\_domain) | The Cognito User Pool Domain. |
| <a name="output_email_configuration"></a> [email\_configuration](#output\_email\_configuration) | The Cognito Email Configuration supported by SES. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->