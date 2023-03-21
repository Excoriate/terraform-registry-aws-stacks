output "is_enabled" {
  value       = module.main_module.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = module.main_module.aws_region_for_deploy_this
  description = "The AWS region where the module is deployed."
}

output "tags_set" {
  value       = module.main_module.tags_set
  description = "The tags set for the module."
}

/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "secret" {
  value       = module.main_module.secret
  description = "The secret id."
}

output "permissions" {
  value       = module.main_module.permissions
  description = "The stack 'secret' permissions generated as part of the options passed"
}
