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

data "aws_lb_listener" "http_listener" {
  for_each          = !local.is_http_enabled ? {} : !local.is_https_redirection_enabled ? {} : { enabled = true }
  load_balancer_arn = data.aws_alb.this[each.key].arn
  port              = 80

  depends_on = [
    module.alb_listeners,
    module.alb_target_group,
    module.alb,
    module.alb_listener_rule_always_redirect_to_https
  ]
}
