<!-- BEGIN_TF_DOCS -->
# ☁️ AWS ALB HTTP stack
## Description

This module implement several components, to allow the creation of an HTTP/s API, service or job that act as a backend, fronted by a set of listeners and a load balancer.
* 🚀 Create an ALB
* 🚀 Create one or many listeners, with one or many rules.
* 🚀 Add the necessary security group rules

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../modules/stack-alb-http"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  vpc_name                = var.vpc_name
  stack                   = var.stack
  http_config             = var.http_config
  health_check_config     = var.health_check_config
  alb_targets_warmup_time = var.alb_targets_warmup_time
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
output "stack_network_configuration" {
  value       = module.network_data
  description = "The network configuration for the stack."
}

output "stack_alb_security_group" {
  value       = module.alb_security_group
  description = "The security group of the Applicatio Load Balancer."
}

output "stack_alb" {
  value       = module.alb
  description = "The Application Load Balancer."
}

output "stack_alb_target_group" {
  value       = module.alb_target_group
  description = "All exported attributes from the ALB target groups configured."
}

output "stack_subnets_public" {
  value = {
    az_a = local.subnet_az_a_id
    az_b = local.subnet_az_b_id
    az_c = local.subnet_az_c_id
  }
  description = "The subnets where the module is deployed."
}

output "stack_alb_certificate_arn" {
  value       = local.certificate_arn
  description = "The ARN of the certificate used by the Application Load Balancer."
}

output "stack_zone_id" {
  value       = local.zone_id
  description = "The ID of the Route53 zone."
}

output "stack_listeners" {
  value       = module.alb_listeners
  description = "The listeners configured for the Application Load Balancer."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb | v1.20.0 |
| <a name="module_alb_listeners"></a> [alb\_listeners](#module\_alb\_listeners) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb-listener | v1.20.0 |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group | v1.20.0 |
| <a name="module_alb_target_group"></a> [alb\_target\_group](#module\_alb\_target\_group) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/target-group | v1.20.0 |
| <a name="module_network_data"></a> [network\_data](#module\_network\_data) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data | v1.20.0 |

## Resources

| Name | Type |
|------|------|
| [aws_alb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |
| [aws_alb_target_group.tg_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb_target_group) | data source |
| [aws_alb_target_group.tg_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb_target_group) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_targets_warmup_time"></a> [alb\_targets\_warmup\_time](#input\_alb\_targets\_warmup\_time) | The amount of time, in seconds, to wait before the first health check after the ALB is created. This<br>options maps to the target\_group configuration attribute 'slow\_start'<br>For more information, please refer to the following link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#slow_start | `number` | `30` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_health_check_config"></a> [health\_check\_config](#input\_health\_check\_config) | Configuration for the health check. Current allowed attributes are:<br>  - timeout: The amount of time, in seconds, during which no response means a failed health check. Default is 5.<br>  - interval: The approximate amount of time, in seconds, between health checks of an individual target. Default is 30.<br>  - threshold: The number of consecutive health check failures required before considering a target unhealthy. Default is 5.<br>  Each of these attributes maps to the target\_group configuration attribute 'health\_check'.<br>  - backend\_port: The port to use for the health check. Default is 8080. | <pre>object({<br>    timeout      = optional(number, 5)<br>    interval     = optional(number, 30)<br>    threshold    = optional(number, 5)<br>    backend_port = number<br>  })</pre> | <pre>{<br>  "backend_port": 8080,<br>  "interval": 30,<br>  "threshold": 3,<br>  "timeout": 3<br>}</pre> | no |
| <a name="input_http_config"></a> [http\_config](#input\_http\_config) | Configuration for HTTP and HTTPS. Current allowed attributes are:<br>  - enable\_http: Whether to enable HTTP or not. Default is true.<br>  - enable\_https: Whether to enable HTTPS or not. Default is false.<br>  - domain: Domain name to use for HTTPS. Default is empty string. | <pre>object({<br>    enable_http  = optional(bool, true)<br>    enable_https = optional(bool, false)<br>    domain       = string<br>  })</pre> | n/a | yes |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_is_internet_facing"></a> [is\_internet\_facing](#input\_is\_internet\_facing) | Whether the ALB is internet facing or not. | `bool` | `true` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Name of the stack. | `string` | n/a | yes |
| <a name="input_stack_prefix"></a> [stack\_prefix](#input\_stack\_prefix) | Prefix for the stack | `string` | `"stack"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC. This variable is used to fetch the VPC, Ids, subnets, etc. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_stack_alb"></a> [stack\_alb](#output\_stack\_alb) | The Application Load Balancer. |
| <a name="output_stack_alb_certificate_arn"></a> [stack\_alb\_certificate\_arn](#output\_stack\_alb\_certificate\_arn) | The ARN of the certificate used by the Application Load Balancer. |
| <a name="output_stack_alb_security_group"></a> [stack\_alb\_security\_group](#output\_stack\_alb\_security\_group) | The security group of the Applicatio Load Balancer. |
| <a name="output_stack_alb_target_group"></a> [stack\_alb\_target\_group](#output\_stack\_alb\_target\_group) | All exported attributes from the ALB target groups configured. |
| <a name="output_stack_listeners"></a> [stack\_listeners](#output\_stack\_listeners) | The listeners configured for the Application Load Balancer. |
| <a name="output_stack_network_configuration"></a> [stack\_network\_configuration](#output\_stack\_network\_configuration) | The network configuration for the stack. |
| <a name="output_stack_subnets_public"></a> [stack\_subnets\_public](#output\_stack\_subnets\_public) | The subnets where the module is deployed. |
| <a name="output_stack_zone_id"></a> [stack\_zone\_id](#output\_stack\_zone\_id) | The ID of the Route53 zone. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
