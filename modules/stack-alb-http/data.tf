data "aws_alb_target_group" "tg_http" {
  for_each = !local.is_http_enabled ? {} : { enabled = true }
  name     = local.target_group_name_http

  depends_on = [
    module.alb_target_group
  ]
}

data "aws_alb_target_group" "tg_https" {
  for_each = !local.is_https_enabled ? {} : { enabled = true }
  name     = local.target_group_name_https

  depends_on = [
    module.alb_target_group
  ]
}

data "aws_alb" "this" {
  for_each = !local.is_enabled ? {} : { enabled = true }
  name     = format("%s-alb", local.stack_full)

  depends_on = [
    module.alb
  ]
}
