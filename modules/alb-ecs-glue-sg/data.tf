# ALB
# 1. Get the ALB
# 2. Get the ALB SG
data "aws_alb" "this" {
  for_each = local.create
  name = each.value["alb"]
}

data "aws_security_group" "alb_sg" {
  for_each = local.create
  id = data.aws_alb.this[each.key].security_groups[0]
}

# ECS
# 1. Fetching the cluster
# 2. Fetching the service
# 3. Fetching the security group id of the service
data "aws_ecs_cluster" "this" {
  for_each = local.create
  cluster_name = local.create[each.key]["cluster"]
}

data "aws_ecs_service" "this" {
  for_each = local.create
  service_name = local.create[each.key]["service"]
  cluster_arn = data.aws_ecs_cluster.this[each.key].arn
}

data "aws_security_group" "ecs_sg" {
  for_each = local.create
  id = tolist(data.aws_ecs_service.this[each.key]["network_configuration"][0]["security_groups"])[0]
}
