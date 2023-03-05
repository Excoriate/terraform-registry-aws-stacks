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
