resource "aws_security_group_rule" "alb_outbound_to_ecs" {
  for_each = local.sg_rules_to_create
  type              = "egress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "tcp"
  security_group_id = lookup(data.aws_security_group.alb_sg[each.value["stack"]], "id", null)
  source_security_group_id = lookup(data.aws_security_group.ecs_sg[each.value["stack"]], "id", null)
}

resource "aws_security_group_rule" "ecs_inbound_from_alb" {
  for_each = local.sg_rules_to_create
  type              = "ingress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "tcp"
  security_group_id = data.aws_security_group.ecs_sg[each.value["stack"]].id
  source_security_group_id = data.aws_security_group.alb_sg[each.value["stack"]].id
}
