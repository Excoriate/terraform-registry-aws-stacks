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

variable "environment" {
  type        = string
  description = <<EOF
Target environment where this stack will be deployed. Since it's a multi-account stack that applies
differently depending on the environment, this input variable is compared with the
'target_environment' attribute of each configuration.
EOF
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/
variable "master_account_config" {
  type = object({
    domain                 = string
    target_env             = string
    environments_to_create = list(object({ name = string, name_servers = list(string), ttl = number }))
  })
}

variable "environments_config" {
  type = list(object({
    subdomain  = string
    target_env = string
    child_zones = list(object({
      name = string
      ttl  = number
    }))
  }))
}
