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
