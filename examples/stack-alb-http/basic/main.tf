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
