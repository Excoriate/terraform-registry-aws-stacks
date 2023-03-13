aws_region = "us-east-1"
is_enabled = true

// Subnets tsn-sandbox-us-east-1-network-core-cross-vpc-backbone-public-us-east-1b
vpc_name = "tsn-sandbox-us-east-1-network-core-cross-vpc-backbone"
stack    = "test"

port_config = {
  listening_port = 443
  container_port = 80 // testing nginx image.
}

http_config = {
  enable_https = true
  enable_http  = true
}

cluster       = "tsn-sandbox-us-east-1-frontend-workload-web-ecs-fargate"
alb_name      = "stack-test-alb"
workload_name = "auth-svc"

container_config = {
  image_url = "nginx:latest"
  memory    = 512
  cpu       = 256
}

scaling_up_max_capacity                 = 2
attach_ingress_alb_target_group_by_name = ["stack-test-alb-tg-http"]
