module "main_module" {
  source     = "../../../modules/stack-alb-http"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  vpc_name = var.vpc_name
  stack    = var.stack
}
