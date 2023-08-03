variable "is_enabled" {
  type        = bool
  description = <<EOF
  Whether this module will be created or not. It is useful, for stack-composite
modules that conditionally includes resources provided by this module..
EOF
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/

variable "alb_name"{
  type = string
  description = <<EOF
  The name of the ALB. Ensure it's an existing ALB, since it's going to be used
for a datasource to discover this resource in AWS.
EOF
}

variable "ecs_service_name"{
  type = string
  description = <<EOF
  The name of the ECS service. Ensure it's an existing ECS service, since it's going to be used
for a datasource to discover this resource in AWS.
EOF
}

variable "ecs_cluster_name"{
  type = string
  description = <<EOF
  The name of the ECS cluster. Ensure it's an existing ECS cluster, since it's going to be used
for a datasource to discover this resource in AWS.
EOF
}
