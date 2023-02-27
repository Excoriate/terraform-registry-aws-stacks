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

/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "feature_flags" {
  value = {
    is_enabled                = var.is_enabled
    is_master_account_enabled = local.is_master_config_enabled
  }
  description = "Describes the feature flags used by this module and their status."
}

output "master_account_config" {
  value       = module.master_hosted_zone
  description = "Expose the entire configuration object of the DNS zone in the master account."
}

output "envs_config" {
  value       = module.envs_hosted_zones
  description = "Expose the entire configuration object of the DNS zone in the environment accounts."
}

output "target_environment" {
  value       = var.environment
  description = "The target environment for the module."
}
