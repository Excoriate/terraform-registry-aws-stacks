locals {
  is_enabled= var.is_enabled

  aws_region_to_deploy = var.aws_region

  stack_config = !local.is_enabled ? [] : [
    {
      name   = format("stack-%s-glue-to-%s", var.alb_name, var.ecs_security_group_name)
      alb_name = var.alb_name
      ecs_sg_name = var.ecs_security_group_name
    }
  ]

  // Create a map with the key as the stack name
  stack = !local.is_enabled ? {} : {
    for stack in local.stack_config :
    stack["name"] => {
      alb_name = trimspace(stack["alb_name"])
      ecs_sg_name = trimspace(stack["ecs_sg_name"])
    }
  }

  // Manage port binding.
  port_binding = !local.is_enabled ? [] : [
    for p in var.ports_to_bind :{
      rule_name = format("port-%s", p)
      stack = format("stack-%s-glue-to-%s", var.alb_name, var.ecs_security_group_name)
      port = p
    }
  ]

  sg_rules_to_create = !local.is_enabled ? {} : {for p in local.port_binding : p["rule_name"] => p }
}
