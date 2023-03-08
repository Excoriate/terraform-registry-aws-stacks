data "aws_alb" "this" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  name     = trimspace(var.alb_name)
}

data "aws_security_group" "this" {
  for_each = !local.is_enabled ? {} : local.stack_config_map
  id       = tolist(lookup(local.alb_data[local.stack], "security_groups"))[0]

  depends_on = [
    data.aws_alb.this
  ]
}
