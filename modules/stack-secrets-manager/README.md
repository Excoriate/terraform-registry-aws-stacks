<!-- BEGIN_TF_DOCS -->
# ☁️ AWS Secrets manager stack
## Description

This stack module creates a secret in AWS Secrets Manager, and optionally, add IAM policies that can be attached if permissions are required.
* 🚀 Create a secret in AWS Secrets Manager
* 🚀 Create IAM policies.
* 🚀 Set custom permissions for the secret policies

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../modules/stack-secrets-manager"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  secret_name             = var.secret_name
  stack                   = var.stack
  stack_prefix            = var.stack_prefix
  secret_prefix_enforced  = var.secret_prefix_enforced
  recovery_window_in_days = var.recovery_window_in_days
  replicate_in_regions    = var.replicate_in_regions
  permissions             = var.permissions
}
```
For an example that pass custom permissions to auto-generate an IAM policy, see:
```hcl
aws_region = "us-east-1"
is_enabled = true

stack = "test"

secret_name          = "test/stack/terraform5"
replicate_in_regions = ["us-west-2", "sa-east-1", "eu-central-1"]
permissions          = ["GetSecretValue", "PutSecretValue", "DeleteSecretValue", "DescribeSecret", "ListSecrets", "ListSecretVersionIds", "DescribeSecretVersion", "RestoreSecret", "RotateSecret", "UpdateSecret", "UpdateSecretVersionStage", "TagResource"]

```
For an example that creates a secret with regional replication, see:
```hcl
aws_region = "us-east-1"
is_enabled = true

stack = "test"

secret_name          = "test/stack/terraform2"
replicate_in_regions = ["us-west-2", "sa-east-1", "eu-central-1"]

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
output "secret" {
  value       = module.secret
  description = "The secret id."
}

output "permissions" {
  value       = module.permission
  description = "The stack 'secret' permissions generated as part of the options passed"
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
| <a name="module_permission"></a> [permission](#module\_permission) | ../../../terraform-registry-aws-storage/modules/secrets-manager-permissions | n/a |
| <a name="module_secret"></a> [secret](#module\_secret) | ../../../terraform-registry-aws-storage/modules/secrets-manager | n/a |

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
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | List of permissions that'll be used to generate an IAM policy for this secret. E.g.:<br>  [<br>    "GetSecretValue",<br>    "DescribeSecret",<br>    "ListSecretVersionIds"<br>  ]<br> It's important to notice that there is no required the 'secretsmanager:' prefix for the permissions, since it's normalised<br>and automatically resolved by this module. | `list(string)` | `[]` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | The number of days that AWS Secrets Manager waits before it can delete the secret. | `number` | `30` | no |
| <a name="input_replicate_in_regions"></a> [replicate\_in\_regions](#input\_replicate\_in\_regions) | List of objects that contains the region and the KMS key ID to be used for replication. | `list(string)` | `null` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of the secret to be created | `string` | n/a | yes |
| <a name="input_secret_prefix_enforced"></a> [secret\_prefix\_enforced](#input\_secret\_prefix\_enforced) | Specifies whether the secret path should be prefixes with a certain 'string'<br>E.g.: if the secret\_prefix\_enforced is set to true and the secret\_prefix is set to 'secret' then the secret will be created at 'secret/secret\_name' | `bool` | `null` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Name of the stack. | `string` | n/a | yes |
| <a name="input_stack_prefix"></a> [stack\_prefix](#input\_stack\_prefix) | Prefix for the stack | `string` | `"stack"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_permissions"></a> [permissions](#output\_permissions) | The stack 'secret' permissions generated as part of the options passed |
| <a name="output_secret"></a> [secret](#output\_secret) | The secret id. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
