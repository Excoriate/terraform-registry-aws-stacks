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
  value       = data.aws_alb.this
  description = "The ALB resource."
}

output "alb_sg" {
  value       = data.aws_security_group.alb_sg
  description = "The ALB security group resource."
}

output "ecs_sg" {
  value       = data.aws_security_group.ecs_sg
  description = "The ECS security group resource."
}

output "rules"{
  value       = local.sg_rules_to_create
  description = "The rules object of the security groups."
}
