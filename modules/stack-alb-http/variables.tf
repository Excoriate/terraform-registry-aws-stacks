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
variable "vpc_name" {
  type        = string
  description = <<EOF
Name of the VPC. This variable is used to fetch the VPC, Ids, subnets, etc.
EOF
}

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

variable "is_internet_facing" {
  type        = bool
  description = <<EOF
Whether the ALB is internet facing or not.
EOF
  default     = true
}

variable "http_config" {
  type = object({
    enable_http  = optional(bool, true)
    enable_https = optional(bool, false)
    domain       = string
  })
  description = <<EOF
  Configuration for HTTP and HTTPS. Current allowed attributes are:
  - enable_http: Whether to enable HTTP or not. Default is true.
  - enable_https: Whether to enable HTTPS or not. Default is false.
  - domain: Domain name to use for HTTPS. Default is empty string.
  EOF
}

variable "alb_targets_warmup_time" {
  type        = number
  description = <<EOF
  The amount of time, in seconds, to wait before the first health check after the ALB is created. This
options maps to the target_group configuration attribute 'slow_start'
For more information, please refer to the following link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#slow_start
  EOF
  default     = 30
}

variable "health_check_config" {
  type = object({
    timeout   = optional(number, 5)
    interval  = optional(number, 30)
    threshold = optional(number, 5)
  })
  description = <<EOF
  Configuration for the health check. Current allowed attributes are:
  - timeout: The amount of time, in seconds, during which no response means a failed health check. Default is 5.
  - interval: The approximate amount of time, in seconds, between health checks of an individual target. Default is 30.
  - threshold: The number of consecutive health check failures required before considering a target unhealthy. Default is 5.
  Each of these attributes maps to the target_group configuration attribute 'health_check'.
  EOF
  default = {
    timeout   = 3
    interval  = 30
    threshold = 3
  }
}
