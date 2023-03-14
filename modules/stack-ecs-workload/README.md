<!-- BEGIN_TF_DOCS -->
# ☁️ AWS Account Creator Module
## Description

This module creates one or many new AWS accounts, linked to either a new or existing AWS organization. It sets up service principals and organizational units if specified.
A summary of its main features:
* 🚀 Create multiple AWS accounts.
* 🚀 Create a new AWS organization or link to an existing one.
* 🚀 Add organisational units or create accounts directly linked to the root AWS organization.
* 🚀 Add and customize service principals.

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
output "stack_vpc_data" {
  value       = local.vpc_data
  description = "The stack VPC data."
}

output "stack_alb_data" {
  value       = local.alb_data
  description = "The stack ALB data."
}

output "stack_security_group_data" {
  value       = module.ecs_security_group
  description = "The stack security group data."
}

output "stack_log_group_data" {
  value       = module.ecs_log_group
  description = "The stack log group data."
}

output "stack_container_definition" {
  value       = module.ecs_container_definition
  description = "The stack container definition."
  sensitive   = true
}

output "stack_ecs_execution_role" {
  value       = module.ecs_execution_role
  description = "The stack ECS execution role."
}

output "stack_ecs_task_role" {
  value       = module.ecs_task_role
  description = "The stack ECS task role."
}

output "stack_ecs_task_definition" {
  value       = module.ecs_task_definition
  description = "The stack ECS task."
}

output "stack_ecs_alb_attachment" {
  value = {
    tg_to_attach          = local.target_groups_to_attach
    is_attachment_enabled = local.is_alb_attachment_by_ecs_enabled
    tg_resolved_data      = local.ecs_load_balancers_config
  }
  description = "The stack ECS ALB attachment."
}

output "stack_auto_scaling" {
  value       = module.ecs_auto_scaling
  description = "The stack auto scaling."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_auto_scaling"></a> [ecs\_auto\_scaling](#module\_ecs\_auto\_scaling) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/auto-scaling/app-auto-scaling | v0.14.0 |
| <a name="module_ecs_container_definition"></a> [ecs\_container\_definition](#module\_ecs\_container\_definition) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-container-definition | v0.14.0 |
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles | v0.14.0 |
| <a name="module_ecs_log_group"></a> [ecs\_log\_group](#module\_ecs\_log\_group) | git::github.com/Excoriate/terraform-registry-observability//modules/aws/cloudwatch-log-group | v0.1.0 |
| <a name="module_ecs_security_group"></a> [ecs\_security\_group](#module\_ecs\_security\_group) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group | v1.23.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-service | v0.14.0 |
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-task | v0.14.0 |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | git::github.com/Excoriate/terraform-registry-aws-containers//modules/ecs-roles | v0.14.0 |
| <a name="module_network_data"></a> [network\_data](#module\_network\_data) | git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data | v1.23.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.outbound_traffic_to_ecs_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_alb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_lb_target_group.tg_to_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The name of the ALB. It's used to also fetch a couple of other attributes, like the<br>security group and the subnets. | `string` | n/a | yes |
| <a name="input_attach_ingress_alb_target_group_by_name"></a> [attach\_ingress\_alb\_target\_group\_by\_name](#input\_attach\_ingress\_alb\_target\_group\_by\_name) | If it's passed, it'll look for a valid ALB (existing) target group, and gets its ARN.<br>It'll be used to attach the ECS service to the ALB. | `list(string)` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The name of the cluster that hosts the service. | `string` | n/a | yes |
| <a name="input_container_config"></a> [container\_config](#input\_container\_config) | Configuration for the container. Current allowed attributes are:<br>  - image\_url: The image to use for the container.<br>  - image\_tag: The image tag to use for the container. Default is null.<br>  - memory: The amount of memory (in MiB) to allow the container to use.<br>  - cpu: The number of cpu units to reserve for the container.<br>  - essential: Whether the container is essential or not. Default is true.<br>  - environment\_variables: A list of maps that contains the environment variables.<br>    - name: The name of the environment variable.<br>    - value: The value of the environment variable.<br>  - permissions: A list of objects that contains the permissions for the container.<br>    - policy\_name: The name of the policy.<br>    - type: The type of permission. Default is Allow.<br>    - actions: A list of actions that the container can perform.<br>    - resources: A list of resources that the container can access. | <pre>object({<br>    image_url             = string<br>    image_tag             = optional(string, null)<br>    memory                = number<br>    cpu                   = number<br>    essential             = optional(bool, true)<br>    environment_variables = optional(list(map(string)), [])<br>    permissions = optional(list(object({<br>      type        = optional(string, "Allow")<br>      policy_name = string<br>      actions     = list(string)<br>      resources   = optional(list(string), ["*"])<br>    })), null)<br>  })</pre> | n/a | yes |
| <a name="input_http_config"></a> [http\_config](#input\_http\_config) | Configuration for HTTP and HTTPS. Current allowed attributes are:<br>  - enable\_http: Whether to enable HTTP or not. Default is true.<br>  - enable\_https: Whether to enable HTTPS or not. Default is false. | <pre>object({<br>    enable_http  = optional(bool, true)<br>    enable_https = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_manage_ecs_service_out_of_terraform"></a> [manage\_ecs\_service\_out\_of\_terraform](#input\_manage\_ecs\_service\_out\_of\_terraform) | Whether to manage the ECS service out of terraform or not. If set to true, the<br>  module will not create the ECS service, but it'll create and managet the ecs service<br>ignoring changes related to 'desired\_count' and 'task\_definitions' related changes. | `bool` | `false` | no |
| <a name="input_port_config"></a> [port\_config](#input\_port\_config) | A list of objects that contains the listening port and the container port.<br>  - listening\_port: The listening port that's configured on the load balancer.<br>  - container\_port: The container port that's configured on the container. | <pre>object({<br>    listening_port = number<br>    container_port = number<br>  })</pre> | n/a | yes |
| <a name="input_scaling_base_capacity"></a> [scaling\_base\_capacity](#input\_scaling\_base\_capacity) | The minimum number of tasks, specified as a percentage of the Amazon ECS service's<br>desiredCount value, that must remain running and healthy in a service during a scaling<br>activity. | `number` | `1` | no |
| <a name="input_scaling_up_max_capacity"></a> [scaling\_up\_max\_capacity](#input\_scaling\_up\_max\_capacity) | The maximum number of tasks, specified as a percentage of the Amazon ECS service's<br>desiredCount value, that can run in a service during a scaling activity. | `number` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Name of the stack. | `string` | n/a | yes |
| <a name="input_stack_prefix"></a> [stack\_prefix](#input\_stack\_prefix) | Prefix for the stack | `string` | `"stack"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC. This variable is used to fetch the VPC, Ids, subnets, etc. | `string` | n/a | yes |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | This variable defines the ecs service name, and the name of the task definition. Logically,<br>it should also represent the service/app that's being deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_stack_alb_data"></a> [stack\_alb\_data](#output\_stack\_alb\_data) | The stack ALB data. |
| <a name="output_stack_auto_scaling"></a> [stack\_auto\_scaling](#output\_stack\_auto\_scaling) | The stack auto scaling. |
| <a name="output_stack_container_definition"></a> [stack\_container\_definition](#output\_stack\_container\_definition) | The stack container definition. |
| <a name="output_stack_ecs_alb_attachment"></a> [stack\_ecs\_alb\_attachment](#output\_stack\_ecs\_alb\_attachment) | The stack ECS ALB attachment. |
| <a name="output_stack_ecs_execution_role"></a> [stack\_ecs\_execution\_role](#output\_stack\_ecs\_execution\_role) | The stack ECS execution role. |
| <a name="output_stack_ecs_task_definition"></a> [stack\_ecs\_task\_definition](#output\_stack\_ecs\_task\_definition) | The stack ECS task. |
| <a name="output_stack_ecs_task_role"></a> [stack\_ecs\_task\_role](#output\_stack\_ecs\_task\_role) | The stack ECS task role. |
| <a name="output_stack_log_group_data"></a> [stack\_log\_group\_data](#output\_stack\_log\_group\_data) | The stack log group data. |
| <a name="output_stack_security_group_data"></a> [stack\_security\_group\_data](#output\_stack\_security\_group\_data) | The stack security group data. |
| <a name="output_stack_vpc_data"></a> [stack\_vpc\_data](#output\_stack\_vpc\_data) | The stack VPC data. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
