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
output "alb" {
  value       = module.main_module.alb
  description = "The ALB resource."
}

output "alb_sg" {
  value       = module.main_module.alb_sg
  description = "The ALB security group resource."
}

output "ecs_sg" {
  value       = module.main_module.ecs_sg
  description = "The ECS security group resource."
}
