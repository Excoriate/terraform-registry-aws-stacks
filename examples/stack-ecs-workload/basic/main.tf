module "main_module" {
  source     = "../../../modules/stack-ecs-workload"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  cluster          = var.cluster
  port_config      = var.port_config
  stack            = var.stack
  vpc_name         = var.vpc_name
  alb_name         = var.alb_name
  http_config      = var.http_config
  workload_name    = var.workload_name
  container_config = var.container_config
}
