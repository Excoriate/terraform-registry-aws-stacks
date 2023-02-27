locals {
  aws_region_to_deploy = var.aws_region

  //1. Enable master 'hosted zone' creation
  master_account_enable_config = !var.is_enabled ? false : var.master_account_config != null && var.master_account_config.target_env == var.environment
}
