data "aws_alb" "this" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  name     = trimspace(var.alb_name)
}

data "aws_security_group" "alb_sg" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  id       = tolist(lookup(local.alb_data[local.stack], "security_groups"))[0]

  depends_on = [
    data.aws_alb.this
  ]
}

data "aws_iam_role" "execution_role" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  name     = format("%s-ecs-exec-role", trimspace(local.container_exec_role_name))

  depends_on = [
    module.ecs_execution_role
  ]
}

data "aws_iam_role" "task_role" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  name     = format("%s-task-exec-role", trimspace(local.container_task_role_name))

  depends_on = [
    module.ecs_task_role
  ]
}

data "aws_ecs_cluster" "this" {
  for_each     = !local.is_enabled ? {} : local.stack_config_map
  cluster_name = local.cluster_name_normalised
}

data "aws_lb_target_group" "tg_to_attach" {
  for_each = !local.is_alb_attachment_by_ecs_enabled ? {} : local.target_groups_to_attach
  name     = each.value["name"]
}
