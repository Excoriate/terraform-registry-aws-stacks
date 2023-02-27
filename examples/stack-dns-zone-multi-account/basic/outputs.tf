output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = module.main_module.aws_region_for_deploy_this
  description = "The AWS region where the module is deployed."
}

output "tags_set" {
  value       = var.tags
  description = "The tags set for the module."
}

/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "feature_flags" {
  value       = module.main_module.feature_flags
  description = "Describes the feature flags used by this module and their status."
}

output "master_account_config" {
  value       = module.main_module.master_account_config
  description = "Expose the entire configuration object of the DNS zone in the master account."
}

output "envs_config" {
  value       = module.main_module.envs_config
  description = "Expose the entire configuration object of the DNS zone in the environment accounts."
}

output "target_environment" {
  value       = module.main_module.target_environment
  description = "The target environment for the module."
}
