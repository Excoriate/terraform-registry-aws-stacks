resource "aws_security_group_rule" "alb_outbound_to_ecs" {
  for_each = local.stack
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = lookup(data.aws_security_group.alb_sg[each.key], "id", null)
  source_security_group_id = lookup(data.aws_security_group.ecs_sg[each.key], "id", null)
}

resource "aws_security_group_rule" "ecs_inbound_from_alb" {
  for_each = local.stack
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = data.aws_security_group.ecs_sg[each.key].id
  source_security_group_id = data.aws_security_group.alb_sg[each.key].id
}
