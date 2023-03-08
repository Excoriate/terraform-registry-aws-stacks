locals {
  vpc_data           = !local.is_enabled ? null : lookup(module.network_data[local.stack]["vpc_data"], local.vpc_name_normalised)
  subnet_public_az_a = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_a_data"], local.vpc_name_normalised)
  subnet_public_az_b = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_b_data"], local.vpc_name_normalised)
  subnet_public_az_c = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_c_data"], local.vpc_name_normalised)

  vpc_id         = lookup(local.vpc_data, "id")
  subnet_az_a_id = lookup(local.subnet_public_az_a, "id")
  subnet_az_b_id = lookup(local.subnet_public_az_b, "id")
  subnet_az_c_id = lookup(local.subnet_public_az_c, "id")

  certificate_data       = !local.is_enabled ? null : lookup(module.network_data[local.stack]["dns_data_acm_certificate"], local.domain_name_normalised)
  zone_data              = !local.is_enabled ? null : lookup(module.network_data[local.stack]["dns_data_hosted_zone"], local.domain_name_normalised)
  certificate_arn        = lookup(local.certificate_data, "arn")
  certificate_ssl_policy = !local.is_enabled ? null : local.certificate_arn == null ? null : "ELBSecurityPolicy-2016-08"
  zone_id                = lookup(local.zone_data, "id")
}

// 1. Lookup for required network data (VPC, and subnets)
module "network_data" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data?ref=v1.19.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  // Fetch VPC and network-related data.
  vpc_data = {
    name                     = local.vpc_name_normalised
    retrieve_subnets_private = true
    retrieve_subnets_public  = true
    filter_by_az             = true
  }

  // Fetch DNS-related data.
  dns_data = {
    domain                = local.domain_name_normalised
    fetch_zone            = true
    fetch_acm_certificate = true
  }

  tags = local.tags
}

// 2. Create a security group for the ALB
module "alb_security_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group?ref=v1.19.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  security_group_config = [
    {
      name        = format("%s-alb-sg", local.stack_full)
      description = format("Firewall test 1 for %s stack", local.stack_full)
      vpc_id      = local.vpc_id
    }
  ]

  security_group_rules_ooo = [
    {
      sg_parent                         = format("%s-alb-sg", local.stack_full)
      enable_inbound_http               = local.is_http_enabled
      enable_inbound_https              = local.is_https_enabled
      enable_inbound_icmp_from_anywhere = true
    }
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

// 3. Create the ALB. If it's set as internet facing, lookup for the public subnets
module "alb" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb?ref=v1.19.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  alb_config = [
    {
      name                             = format("%s-alb", local.stack_full)
      subnets_public                   = [local.subnet_az_a_id, local.subnet_az_b_id, local.subnet_az_c_id]
      is_internal                      = var.is_internet_facing ? false : true
      enable_http2                     = true
      enable_cross_zone_load_balancing = true
      security_groups = [
        for sg in module.alb_security_group[local.stack]["sg_id"] : sg
      ]
    }
  ]

  tags = local.tags
}

// 4. "Target group" for the ALB.
locals {
  // 4.1. Create a target group for the ALB for HTTP traffic.
  target_group_defaults = {
    vpc_id           = local.vpc_id
    protocol_version = "HTTP2"
    protocol         = "TCP"
    slow_start       = var.alb_targets_warmup_time
  }

  // 4.2. Opinionated defaults for the health check.
  target_group_health_check_defaults = {
    enabled             = true
    path                = "/"
    healthy_threshold   = var.health_check_config.threshold
    unhealthy_threshold = var.health_check_config.threshold
    matcher             = "200-299"
    timeout             = var.health_check_config.timeout
    interval            = var.health_check_config.interval
  }
}

module "alb_target_group" {
  for_each = local.stack_config_map
  #  source     = "../../../terraform-registry-aws-networking/modules/target-group"
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/target-group?ref=v1.19.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  target_group_config = [
    // 4.1. Create a target group for the ALB for HTTP traffic.
    !local.is_enabled ? null : !local.is_http_enabled ? null : merge({
      name     = format("%s-alb-tg-http", local.stack_full)
      port     = 80
      protocol = "HTTP"
      health_check = merge({
        protocol = "HTTP"
        port     = 80
      }, local.target_group_health_check_defaults)
    }, local.target_group_defaults),
    // 4.2. Create a target group for the ALB for HTTPS traffic.
    !local.is_enabled ? null : !local.is_https_enabled ? null : merge({
      name     = format("%s-alb-tg-https", local.stack_full)
      port     = 443
      protocol = "HTTPS"
      health_check = merge({
        protocol = "HTTPS"
        port     = 443
      }, local.target_group_health_check_defaults)
    }, local.target_group_defaults)
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

#module "alb_listeners"{
#  for_each  = !local.is_http_enabled && !local.is_https_enabled ? {} : local.stack_config_map
#  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb-listener?ref=v1.18.0"
#  aws_region = var.aws_region
#  is_enabled = var.is_enabled
#
#  alb_listeners_config = [
#    {
#      alb_arn             = module.alb[local.stack]["alb_arn"]
#      port                = 80
#      protocol            = "HTTP"
#      default_action = {
#        type "forward"
#        target_group_arn = null
#      }
#    }
#  ]
#
#  depends_on = [
#    module.alb
#  ]
#
#  tags = local.tags
#}
