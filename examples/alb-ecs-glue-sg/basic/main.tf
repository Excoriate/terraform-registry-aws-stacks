module "main_module" {
  source     = "../../../modules/alb-ecs-glue-sg"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  alb_name         = var.alb_name
  ecs_security_group_name = var.ecs_security_group_name
  ports_to_bind = var.ports_to_bind
}
