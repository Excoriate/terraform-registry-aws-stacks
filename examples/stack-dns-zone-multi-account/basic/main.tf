module "main_module" {
  source      = "../../../modules/stack-dns-zone-multi-account"
  is_enabled  = var.is_enabled
  aws_region  = var.aws_region
  environment = var.environment

  environment_zones_config = var.environment_zones_config
  master_zone_config       = var.master_zone_config
}
