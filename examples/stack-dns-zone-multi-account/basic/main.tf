module "main_module" {
  source                = "../../../modules/stack-dns-zone-multi-account"
  is_enabled            = var.is_enabled
  aws_region            = var.aws_region
  environment           = var.environment
  environments_config   = var.environments_config
  master_account_config = var.master_account_config
}
