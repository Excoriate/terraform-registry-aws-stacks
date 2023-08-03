locals {
  is_enabled= var.is_enabled

  aws_region_to_deploy = var.aws_region

  create = !local.is_enabled ? {} : {
    cfg = {
      id = format("%s-glue-to-%s", var.alb_name, var.ecs_service_name)
      alb = trimspace(var.alb_name)
      ecs = trimspace(var.ecs_service_name)
      cluster = trimspace(var.ecs_cluster_name)
    }
  }
}
