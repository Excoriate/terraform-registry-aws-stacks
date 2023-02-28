<!-- BEGIN_TF_DOCS -->
# ☁️ AWS DNS delegation in a multi-account environment
## Description

This module creates a multi-account setup for DNS delegation. There are several assumptions that should be taken into consideration:
1. There's a `master` account, that's able to override with its `NS` records another account — not managed by this module — which owns the domain.
2. Several "child accounts where it's possible to create environment-specifics `subdomains` (e.g. `dev`, `staging`, `prod`).
3. Optionally, in each of these environment-specific accounts, it's possible to create "child zones" which are used to separate resource types, e.g. `api`, `web`, `db`, etc.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../modules/default"
  is_enabled = var.is_enabled
  aws_region = var.aws_region
}
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
    is_enabled                = var.is_enabled
    is_master_account_enabled = local.is_master_config_enabled
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
| <a name="module_envs_certificates"></a> [envs\_certificates](#module\_envs\_certificates) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.8.0 |
| <a name="module_envs_certificates_per_zone"></a> [envs\_certificates\_per\_zone](#module\_envs\_certificates\_per\_zone) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.8.0 |
| <a name="module_envs_hosted_zones"></a> [envs\_hosted\_zones](#module\_envs\_hosted\_zones) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone | v1.8.0 |
| <a name="module_master_certificate"></a> [master\_certificate](#module\_master\_certificate) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate | v1.8.0 |
| <a name="module_master_hosted_zone"></a> [master\_hosted\_zone](#module\_master\_hosted\_zone) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone | v1.8.0 |

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
| <a name="input_master_zone_config"></a> [master\_zone\_config](#input\_master\_zone\_config) | This configuration allow to create a master hosted zone, either for a single environment or for multiple environments.<br>It also supports the creation of a certificate for the domain.<br>The 'environments\_to\_create' attribute is a list of objects that contains the name of the environment and the name servers:<br>E.g.:<br>{<br>  name\_servers = [<br>    "ns-123.awsdns-12.com",<br>    "ns-456.awsdns-78.net",<br>    "ns-901.awsdns-34.org",<br>    "ns-567.awsdns-90.co.uk"<br>  ]<br>}<br>It's important to mention that the `target_env` is an special attribute that's used to compare with the `environment` input variable, in order to<br>selectively create the resources for the target environment. | <pre>object({<br>    domain                 = string<br>    target_env             = string<br>    environments_to_create = optional(list(object({ name = string, name_servers = list(string), ttl = number })), [])<br>    enable_certificate     = optional(bool, false)<br>  })</pre> | `null` | no |
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
