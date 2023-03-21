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
