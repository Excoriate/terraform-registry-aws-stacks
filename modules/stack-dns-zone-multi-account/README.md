<!-- BEGIN_TF_DOCS -->
# ☁️ AWS DNS delegation in a multi-account environment
## Description

This module creates a multi-account setup for DNS delegation. There are several assumptions that should be taken into consideration:
1. There's a `master` account, that's able to override with its `NS` records another account — not managed by this module — which owns the domain.
2. Several "child accounts where it's possible to create environment-specifics `subdomains` (e.g. `dev`, `staging`, `prod`).
3. Optionally, in each of these environment-specific accounts, it's possible to create "child zones" which are used to separate resource types, e.g. `api`, `web`, `db`, etc.

### How to ensure a prooper configuration
Sadly, isn't the entire process fully automated in a 1-step fashion, due to natural Terraform limitations. Please, ensure that you're following these steps:
1. First, ensure that the `master` zone is created.
2. In the `master` account, pass the NS records that'll hold each `subdomain` per each `environment` (in childs AWS accounts) needed.
E.g.: (from Terragrunt)
```hcl
master_zone_config = {
domain = local.domain
enable_certificate = true
target_env = include.parent.locals.deployment_environment // same environment. E.g.: master
environments_to_create = []
}
```
>Note: The current module already support built-in ACM certificates. If the `enable_certificate` is set to `true`, the module will create a certificate for the `subdomain` and the `apex_domain` (e.g. `example.com`).
3. Per each `subdomain`, it's required to create an object within the `environments_to_create` list, with the following attributes:
- `name`: the name of the `subdomain` (e.g. `sandbox`, `dev`, `staging`, `prod`).
- `name_servers`: the list of `NS` records that'll be used to override the `master` account's `NS` records.
- `ttl`: the TTL for the `NS` records.
4. Normally, the `name_servers` per each subdomain aren't set in the step 3. You have to create them first in their specific AWS child accounts, and obtain from there their `NS` records. This is a manual step, and it's required to be done before the step 6.
5. Create the DNS configuration only applying the changes for the hosted zone first. The ACM certificate will fail in this step if it's created, since it can't be validated if the NS records aren't replaced into the `master` account.
```hcl
environment_zones_config = [
{
subdomain  = "dev.example.com"
target_env = "dev"
child_zones = [
{
name : "api"
ttl = 300
},
{
name : "web"
ttl = 300
}
]
},
{
subdomain                   = "stage.example.com"
target_env                  = "stage"
enable_certificate          = false
enable_certificate_per_zone = false
child_zones = [
{
name : "api"
ttl = 300
},
{
name : "web"
ttl = 300
}
]
}
]

environment = "stage"
```
6. Once you have the `NS` records for each `subdomain`, you can pass them to the `master` account, and create the `subdomain` in the `master` account. E.g.:
```hcl
master_zone_config = {
domain = local.domain
enable_certificate = true
target_env = include.parent.locals.deployment_environment // same environment. E.g.: master
environments_to_create = [
{
name = "sandbox"
name_servers = [
"ns-1498.awsdns-22.org.",
"ns-391.awsdns-11.com.",
"ns-983.awsdns-00.net.",
"ns-1811.awsdns-21.co.uk."
]
ttl = local.ttl
},
]
}
```
7. When the zones are created, and their respective NS records are replaced into the master account, you can apply the changes in each AWS child account but this time enabling the `certificate` creation:
```hcl
environment_zones_config = [
{
subdomain  = "dev.example.com"
target_env = "dev"
child_zones = [
{
name : "api"
ttl = 300
},
{
name : "web"
ttl = 300
}
]
},
{
subdomain                   = "stage.example.com"
target_env                  = "stage"
enable_certificate          = true
enable_certificate_per_zone = true
child_zones = [
{
name : "api"
ttl = 300
},
{
name : "web"
ttl = 300
}
]
}
]

environment = "stage"
```

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source      = "../../../modules/stack-dns-zone-multi-account"
  is_enabled  = var.is_enabled
  aws_region  = var.aws_region
  environment = var.environment

  environment_zones_config = var.environment_zones_config
  master_zone_config       = var.master_zone_config
}
```
An example of a very simple configuration:
```hcl
aws_region = "us-east-1"
is_enabled = true

master_zone_config = {
  domain     = "example.com"
  target_env = "dev"
}

environment = "dev"
```

A configuration that includes "child" zones, meaning environments in AWS managed accounts:
```hcl
aws_region = "us-east-1"
is_enabled = true

environment_zones_config = [
  {
    subdomain  = "dev.example.com"
    target_env = "dev"
    child_zones = [
      {
        name : "api"
        ttl = 300
      },
      {
        name : "web"
        ttl = 300
      }
    ]
  },
  {
    subdomain  = "stage.example.com"
    target_env = "stage"
    child_zones = [
      {
        name : "api"
        ttl = 300
      },
      {
        name : "web"
        ttl = 300
      }
    ]
  }
]

environment = "stage"
```

A configuration for a `master` account, with ACM certificates included:
```hcl
aws_region = "us-east-1"
is_enabled = true

master_zone_config = {
  domain                 = "4id.network"
  target_env             = "master"
  environments_to_create = []
  enable_certificate     = true
}

environment = "master"
```

For module composition, It's recommended to take a look at the module's `outputs` to understand what's available:
```hcl
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
output "feature_flags" {
  value = {
    is_enabled                           = var.is_enabled
    is_master_account_enabled            = local.is_master_config_enabled
    is_master_ns_records_per_env_enabled = local.is_master_environment_ns_records_enabled
    is_envs_zones_enabled                = local.is_envs_config_enabled
  }
  description = "Describes the feature flags used by this module and their status."
}

output "master_account_config" {
  value       = module.master_hosted_zone
  description = "Expose the entire configuration object of the DNS zone in the master account."
}

output "envs_config" {
  value       = module.envs_hosted_zones
  description = "Expose the entire configuration object of the DNS zone in the environment accounts."
}

output "target_environment" {
  value       = var.environment
  description = "The target environment for the module."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_envs_certificates"></a> [envs\_certificates](#module\_envs\_certificates) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.11.0 |
| <a name="module_envs_certificates_per_zone"></a> [envs\_certificates\_per\_zone](#module\_envs\_certificates\_per\_zone) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.11.0 |
| <a name="module_envs_hosted_zones"></a> [envs\_hosted\_zones](#module\_envs\_hosted\_zones) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone | v1.11.0 |
| <a name="module_master_certificate"></a> [master\_certificate](#module\_master\_certificate) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.11.0 |
| <a name="module_master_hosted_zone"></a> [master\_hosted\_zone](#module\_master\_hosted\_zone) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone | v1.11.0 |

## Resources

No resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Target environment where this stack will be deployed. Since it's a multi-account stack that applies<br>differently depending on the environment, this input variable is compared with the<br>'target\_environment' attribute of each configuration. | `string` | n/a | yes |
| <a name="input_environment_zones_config"></a> [environment\_zones\_config](#input\_environment\_zones\_config) | This configuration allow to create a child hosted zone for each environment. The current attributes supported:<br>- subdomain: The subdomain name of the hosted zone.<br>- target\_env: An special attribute that's used to compare with the `environment` input variable, in order to<br>selectively create the resources for the target environment.<br>- enable\_certificate: Whether to create a certificate for the domain.<br>- enable\_certificate\_per\_zone: Whether to create a certificate for each child zone.<br>- child\_zones: A list of objects that contains the name of the child zone and the TTL.<br>E.g.:<br>{<br>  child\_zones = [<br>    {<br>      name = "child-zone-1"<br>      ttl  = 300<br>    },<br>    {<br>      name = "child-zone-2"<br>      ttl  = 300<br>    }<br>  ]<br>} | <pre>list(object({<br>    subdomain                   = string<br>    target_env                  = string<br>    enable_certificate          = optional(bool, false)<br>    enable_certificate_per_zone = optional(bool, false)<br>    child_zones = list(object({<br>      name = string<br>      ttl  = number<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_environments_to_protect_from_destroy"></a> [environments\_to\_protect\_from\_destroy](#input\_environments\_to\_protect\_from\_destroy) | This special input variable set the 'environments' that are protected from being destroyed. This variable is<br>used when the hosted zone is created, in order to set the 'force\_destroy' attribute to 'false' for the<br>environments that are protected from being destroyed. | `list(string)` | `[]` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_master_zone_config"></a> [master\_zone\_config](#input\_master\_zone\_config) | This configuration allow to create a master hosted zone, either for a single environment or for multiple environments.<br>It also supports the creation of a certificate for the domain.<br>The 'environments\_to\_create' attribute is a list of objects that contains the name of the environment and the name servers:<br>E.g.:<br>{<br>  name\_servers = [<br>    "ns-123.awsdns-12.com",<br>    "ns-456.awsdns-78.net",<br>    "ns-901.awsdns-34.org",<br>    "ns-567.awsdns-90.co.uk"<br>  ]<br>}<br>It's important to mention that the `target_env` is an special attribute that's used to compare with the `environment` input variable, in order to<br>selectively create the resources for the target environment. | <pre>object({<br>    domain     = string<br>    target_env = string<br>    environments_to_create = optional(list(object({<br>      name         = string,<br>      name_servers = list(string),<br>      ttl          = number<br>    })), [])<br>    enable_certificate = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_envs_config"></a> [envs\_config](#output\_envs\_config) | Expose the entire configuration object of the DNS zone in the environment accounts. |
| <a name="output_feature_flags"></a> [feature\_flags](#output\_feature\_flags) | Describes the feature flags used by this module and their status. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_master_account_config"></a> [master\_account\_config](#output\_master\_account\_config) | Expose the entire configuration object of the DNS zone in the master account. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
| <a name="output_target_environment"></a> [target\_environment](#output\_target\_environment) | The target environment for the module. |
<!-- END_TF_DOCS -->
