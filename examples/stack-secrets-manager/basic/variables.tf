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

variable "secret_name" {
  type        = string
  description = <<EOF
  Name of the secret to be created
EOF
}

variable "recovery_window_in_days" {
  type        = number
  description = <<EOF
  The number of days that AWS Secrets Manager waits before it can delete the secret.
EOF
  default     = 30
}

variable "secret_prefix_enforced" {
  type        = bool
  description = <<EOF
  Specifies whether the secret path should be prefixes with a certain 'string'
E.g.: if the secret_prefix_enforced is set to true and the secret_prefix is set to 'secret' then the secret will be created at 'secret/secret_name'
EOF
  default     = null
}

variable "replicate_in_regions" {
  type        = list(string)
  description = <<EOF
  List of objects that contains the region and the KMS key ID to be used for replication.
EOF
  default     = null
}

variable "permissions" {
  type        = list(string)
  description = <<EOF
  List of permissions that'll be used to generate an IAM policy for this secret. E.g.:
  [
    "GetSecretValue",
    "DescribeSecret",
    "ListSecretVersionIds"
  ]
 It's important to notice that there is no required the 'secretsmanager:' prefix for the permissions, since it's normalised
and automatically resolved by this module.
EOF
  default     = []
}
