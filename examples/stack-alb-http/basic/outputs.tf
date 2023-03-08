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
output "stack_network_configuration" {
  value       = module.main_module.stack_network_configuration
  description = "The network configuration for the stack."
}

output "stack_alb_security_group" {
  value       = module.main_module.stack_alb_security_group
  description = "The security group of the Applicatio Load Balancer."
}

output "stack_alb" {
  value       = module.main_module.stack_alb
  description = "The Application Load Balancer."
}

output "stack_alb_target_group" {
  value       = module.main_module.stack_alb_target_group
  description = "All exported attributes from the ALB target groups configured."
}

output "stack_subnets_public" {
  value       = module.main_module.stack_subnets_public
  description = "The public subnets for the stack."
}

output "stack_alb_certificate_arn" {
  value       = module.main_module.stack_alb_certificate_arn
  description = "The ARN of the certificate used by the Application Load Balancer."
}

output "stack_zone_id" {
  value       = module.main_module.stack_zone_id
  description = "The ID of the Route53 zone."
}

output "stack_listeners" {
  value       = module.main_module.stack_listeners
  description = "The listeners configured for the Application Load Balancer."
}
