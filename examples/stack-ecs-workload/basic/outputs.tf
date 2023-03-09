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
output "stack_vpc_data" {
  value       = module.main_module.stack_vpc_data
  description = "The stack VPC data."
}

output "stack_alb_data" {
  value       = module.main_module.stack_alb_data
  description = "The stack ALB data."
}

output "stack_security_group_data" {
  value       = module.main_module.stack_security_group_data
  description = "The stack security group data."
}

output "stack_log_group_data" {
  value       = module.main_module.stack_log_group_data
  description = "The stack log group data."
}

output "stack_container_definition" {
  value       = module.main_module.stack_container_definition
  description = "The stack container definition."
  sensitive   = true
}

output "stack_ecs_execution_role" {
  value       = module.main_module.stack_ecs_execution_role
  description = "The stack ECS execution role."
}

output "stack_ecs_task_role" {
  value       = module.main_module.stack_ecs_task_role
  description = "The stack ECS task role."
}
