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
    enable_certificate     = optional(bool, false)
  })
  default     = null
  description = <<EOF
This configuration allow to create a master hosted zone, either for a single environment or for multiple environments.
It also supports the creation of a certificate for the domain.
The 'environments_to_create' attribute is a list of objects that contains the name of the environment and the name servers:
E.g.:
{
  name_servers = [
    "ns-123.awsdns-12.com",
    "ns-456.awsdns-78.net",
    "ns-901.awsdns-34.org",
    "ns-567.awsdns-90.co.uk"
  ]
}
It's important to mention that the `target_env` is an special attribute that's used to compare with the `environment` input variable, in order to
selectively create the resources for the target environment.
EOF
}

variable "environments_config" {
  type = list(object({
    subdomain          = string
    target_env         = string
    enable_certificate = optional(bool, false)
    child_zones = list(object({
      name = string
      ttl  = number
    }))
  }))
  default     = null
  description = <<EOF
This configuration allow to create a child hosted zone for each environment.
It also supports the creation of a certificate for the domain.
The 'child_zones' attribute is a list of objects that contains the name of the child zone and the TTL:
E.g.:
{
  child_zones = [
    {
      name = "api"
      ttl  = 300
    },
    {
      name = "www"
      ttl  = 300
    }
  ]
EOF
}

variable "environments_to_protect_from_destroy" {
  type        = list(string)
  default     = []
  description = <<EOF
This special input variable set the 'environments' that are protected from being destroyed. This variable is
used when the hosted zone is created, in order to set the 'force_destroy' attribute to 'false' for the
environments that are protected from being destroyed.
EOF
}
