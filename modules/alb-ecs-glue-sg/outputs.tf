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

output "alb" {
  value       = data.aws_alb
  description = "The ALB resource."
}

output "ecs_cluster" {
  value       = data.aws_ecs_cluster
  description = "The ECS cluster resource."
}

output "ecs_service" {
  value       = data.aws_ecs_service
  description = "The ECS service resource."
}

output "alb_sg" {
  value       = data.aws_security_group
  description = "The ALB security group resource."
}

output "ecs_sg" {
  value       = data.aws_security_group
  description = "The ECS security group resource."
}
