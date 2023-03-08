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
variable "stack" {
  type        = string
  description = <<EOF
Name of the stack.
EOF
}

variable "stack_prefix" {
  type        = string
  description = "Prefix for the stack"
  default     = "stack"
}

variable "vpc_name" {
  type        = string
  description = <<EOF
Name of the VPC. This variable is used to fetch the VPC, Ids, subnets, etc.
EOF
}

variable "cluster" {
  type        = string
  description = <<EOF
The name of the cluster that hosts the service.
EOF
}

variable "port_config" {
  type = object({
    listening_port = number
    container_port = number
  })
  description = <<EOF
A list of objects that contains the listening port and the container port.
  - listening_port: The listening port that's configured on the load balancer.
  - container_port: The container port that's configured on the container.
EOF
}

variable "alb_name" {
  type        = string
  description = <<EOF
The name of the ALB. It's used to also fetch a couple of other attributes, like the
security group and the subnets.
EOF
}

variable "http_config" {
  type = object({
    enable_http  = optional(bool, true)
    enable_https = optional(bool, false)
  })
  description = <<EOF
  Configuration for HTTP and HTTPS. Current allowed attributes are:
  - enable_http: Whether to enable HTTP or not. Default is true.
  - enable_https: Whether to enable HTTPS or not. Default is false.
  EOF
}

variable "workload_name" {
  type        = string
  description = <<EOF
This variable defines the ecs service name, and the name of the task definition. Logically,
it should also represent the service/app that's being deployed.
EOF
}
