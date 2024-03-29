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

output "stack_container_definition" {
  value       = module.ecs_container_definition
  description = "The stack container definition."
  sensitive   = true
}

output "stack_ecs_execution_role" {
  value       = module.ecs_execution_role
  description = "The stack ECS execution role."
}

output "stack_ecs_task_role" {
  value       = module.ecs_task_role
  description = "The stack ECS task role."
}

output "stack_ecs_task_definition" {
  value       = module.ecs_task_definition
  description = "The stack ECS task."
}

output "stack_ecr" {
  value       = module.ecs_container_registry
  description = "The stack ECR."
}

output "stack_ecs_alb_attachment" {
  value = {
    tg_to_attach          = local.target_groups_to_attach
    is_attachment_enabled = local.is_alb_attachment_by_ecs_enabled
    tg_resolved_data      = local.ecs_load_balancers_config
  }
  description = "The stack ECS ALB attachment."
}

output "stack_auto_scaling" {
  value       = module.ecs_auto_scaling
  description = "The stack auto scaling."
}

output "stack_info" {
  value = {
    stack      = local.stack
    stack_full = local.stack_full
  }
  description = "The stack info."
}
