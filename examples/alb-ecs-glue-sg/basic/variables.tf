variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alb_name"{
  type = string
  description = <<EOF
  The name of the ALB. Ensure it's an existing ALB, since it's going to be used
for a datasource to discover this resource in AWS.
EOF
}

variable "ecs_security_group_name"{
  type = string
  description = <<EOF
  The name of the ECS security group name. It's not yet supported throughout the ecs datasource
to retrieve the 'network' configuration. Therefore, we need to pass it as an input variable.
EOF
}

variable "ports_to_bind"{
  type = list(number)
  description = <<EOF
  The ports to bind to the ALB. It's a list of numbers, since we can bind multiple ports
to the same ALB.
EOF
  default = [80, 443]
}
