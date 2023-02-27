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
    is_master_account_enabled = local.master_account_enable_config
  }
  description = "Describes the feature flags used by this module and their status."
}

output "master_account_config" {
  value       = module.dns_zone_master
  description = "Expose the entire configuration object of the DNS zone in the master account."
}
