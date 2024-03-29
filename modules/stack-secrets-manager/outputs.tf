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
output "secret" {
  value       = module.secret
  description = "The secret id."
}

output "permissions" {
  value       = module.permission
  description = "The stack 'secret' permissions generated as part of the options passed"
}
