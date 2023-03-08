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
output "stack_network_configuration" {
  value       = module.network_data
  description = "The network configuration for the stack."
}

output "stack_alb_security_group" {
  value       = module.alb_security_group
  description = "The security group of the Applicatio Load Balancer."
}

output "stack_alb" {
  value       = module.alb
  description = "The Application Load Balancer."
}

output "stack_alb_target_group" {
  value       = module.alb_target_group
  description = "All exported attributes from the ALB target groups configured."
}

output "stack_subnets_public" {
  value = {
    az_a = local.subnet_az_a_id
    az_b = local.subnet_az_b_id
    az_c = local.subnet_az_c_id
  }
  description = "The subnets where the module is deployed."
}

output "stack_alb_certificate_arn" {
  value       = local.certificate_arn
  description = "The ARN of the certificate used by the Application Load Balancer."
}

output "stack_zone_id" {
  value       = local.zone_id
  description = "The ID of the Route53 zone."
}

output "stack_listeners" {
  value       = module.alb_listeners
  description = "The listeners configured for the Application Load Balancer."
}
