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
output "stack_vpc_data" {
  value       = local.vpc_data
  description = "The stack VPC data."
}

output "stack_alb_data" {
  value       = local.alb_data
  description = "The stack ALB data."
}

output "stack_security_group_data" {
  value       = module.ecs_security_group
  description = "The stack security group data."
}

output "stack_log_group_data" {
  value       = module.ecs_log_group
  description = "The stack log group data."
}
