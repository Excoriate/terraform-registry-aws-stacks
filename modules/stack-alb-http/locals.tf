locals {
  is_enabled           = var.is_enabled ? { is_enabled = true } : {}
  aws_region_to_deploy = var.aws_region
}
