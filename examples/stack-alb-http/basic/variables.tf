variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

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
