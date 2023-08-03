# ALB
# 1. Get the ALB
# 2. Get the ALB SG
data "aws_alb" "this" {
  for_each = local.stack
  name = each.value["alb_name"]
}

data "aws_security_group" "alb_sg" {
  for_each = local.stack
  id = element(tolist(data.aws_alb.this[each.key].security_groups), 0)
}

# ECS
# 1. Fetching the security group id of the service
# Fetch Security Group based on its name
data "aws_security_group" "ecs_sg" {
  for_each = local.stack
  name     = each.value["ecs_sg_name"]
}
