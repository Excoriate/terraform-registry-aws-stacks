locals {
  vpc_data           = !local.is_enabled ? null : lookup(module.network_data[local.stack]["vpc_data"], local.vpc_name_normalised)
  subnet_public_az_a = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_a_data"], local.vpc_name_normalised)
  subnet_public_az_b = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_b_data"], local.vpc_name_normalised)
  subnet_public_az_c = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_az_c_data"], local.vpc_name_normalised)

  vpc_id         = lookup(local.vpc_data, "id")
  subnet_az_a_id = lookup(local.subnet_public_az_a, "id")
  subnet_az_b_id = lookup(local.subnet_public_az_b, "id")
  subnet_az_c_id = lookup(local.subnet_public_az_c, "id")

  certificate_data = !local.is_enabled ? null : lookup(module.network_data[local.stack]["dns_data_acm_certificate"], local.domain_name_normalised)
  zone_data        = !local.is_enabled ? null : lookup(module.network_data[local.stack]["dns_data_hosted_zone"], local.domain_name_normalised)
  certificate_arn  = lookup(local.certificate_data, "arn")
  zone_id          = lookup(local.zone_data, "id")
}

// ***************************************
// 1. Fetch VPC and network-related data.
// ***************************************
module "network_data" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data?ref=v1.30.0"
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

// ***************************************
// 2. ALB security groups
// ***************************************
module "alb_security_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group?ref=v1.30.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  security_group_config = [
    {
      name        = format("%s-alb-sg", local.stack_full)
      description = format("Firewall set of rules for %s stack", local.stack_full)
      vpc_id      = local.vpc_id
    }
  ]

  security_group_rules_ooo = [
    {
      sg_parent                            = format("%s-alb-sg", local.stack_full)
      enable_inbound_http                  = local.is_fronting_a_backend_service_enabled ? false : true
      enable_inbound_https                 = local.is_fronting_a_backend_service_enabled ? false : true
      enable_inbound_icmp_from_anywhere    = true
      custom_port                          = local.is_fronting_a_backend_service_enabled ? var.http_config.backend_port : null
      enable_inbound_from_custom_port_cidr = local.is_fronting_a_backend_service_enabled
    }
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

// ***************************************
// 3. Application load balancer
// ***************************************
module "alb" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb?ref=v1.30.0"
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

// ***************************************
// 4. Target group
// ***************************************
locals {
  // 4.1. Create a target group for the ALB for HTTP traffic.
  target_group_defaults = {
    vpc_id           = local.vpc_id
    protocol_version = "HTTP1"
    slow_start       = var.alb_targets_warmup_time
    target_type      = "ip"
  }

  // 4.2. Opinionated defaults for the health check.
  target_group_health_check_defaults = {
    enabled             = true
    path                = var.health_check_config.path
    healthy_threshold   = var.health_check_config.threshold
    unhealthy_threshold = var.health_check_config.threshold
    matcher             = var.health_check_config.matcher
    timeout             = var.health_check_config.timeout
    interval            = var.health_check_config.interval
    port                = var.health_check_config.backend_port
  }
}

module "alb_target_group" {
  for_each = local.stack_config_map
  #    source     = "../../../terraform-registry-aws-networking/modules/target-group"
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/target-group?ref=v1.29.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  target_group_config = [
    // 4.1. Create a target group for the ALB for HTTP traffic.
    !local.is_enabled ? null : !local.is_http_enabled ? null : merge({
      name     = format("%s-alb-tg-http", local.stack_full)
      port     = var.http_config.backend_port
      protocol = "HTTP"
      health_check = merge({
        protocol = "HTTP"
      }, local.target_group_health_check_defaults)
    }, local.target_group_defaults),
    // 4.2. Create a target group for the ALB for HTTPS traffic.
    !local.is_enabled ? null : !local.is_https_enabled ? null : merge({
      name     = format("%s-alb-tg-https", local.stack_full)
      port     = var.http_config.backend_port
      protocol = "HTTP"
      health_check = merge({
        protocol = "HTTP"
      }, local.target_group_health_check_defaults)
    }, local.target_group_defaults)
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

// ***************************************
// 5. ALB listeners
// ***************************************
locals {
  // 5.1. Create a target group for the ALB for HTTP traffic.
  listener_defaults = {
    alb_arn = join("", [for alb in data.aws_alb.this : alb.arn])
  }

  // 5.2 Handy to get the target group ARN through data sources.
  target_group_name_http  = !local.is_http_enabled ? null : format("%s-alb-tg-http", local.stack_full)
  target_group_name_https = !local.is_https_enabled ? null : format("%s-alb-tg-https", local.stack_full)
  target_group_http_arn   = !local.is_http_enabled ? null : join("", [for tg in data.aws_alb_target_group.tg_http : tg.arn])
  target_group_https_arn  = !local.is_https_enabled ? null : join("", [for tg in data.aws_alb_target_group.tg_https : tg.arn])
}

module "alb_listeners" {
  for_each   = !local.is_http_enabled && !local.is_https_enabled ? {} : local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb-listener?ref=v1.29.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  alb_listener_ooo_http = !local.is_http_enabled ? [] : [
    !local.is_http_enabled ? null : merge({
      name             = format("%s-alb-listener-http", local.stack_full)
      target_group_arn = local.target_group_http_arn
    }, local.listener_defaults)
  ]

  alb_listener_ooo_https = !local.is_https_enabled ? [] : [
    !local.is_https_enabled ? null : merge({
      name             = format("%s-alb-listener-https", local.stack_full)
      certificate_arn  = local.certificate_arn
      target_group_arn = local.target_group_https_arn
    }, local.listener_defaults)
  ]

  tags = local.tags

  depends_on = [
    data.aws_alb_target_group.tg_http,
    data.aws_alb_target_group.tg_https,
    data.aws_alb.this
  ]
}

// ***************************************
// 6. Optional DNS records
// ***************************************
locals {
  alb_zone_id  = !local.is_dns_record_generation_enabled ? null : join("", [for alb in data.aws_alb.this : alb.zone_id])
  alb_dns_name = !local.is_dns_record_generation_enabled ? null : join("", [for alb in data.aws_alb.this : alb.dns_name])
}

module "dns_records" {
  for_each = !local.is_dns_record_generation_enabled ? {} : local.stack_config_map
  source   = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-dns-records?ref=v1.29.0"
  #  source   = "../../../terraform-registry-aws-networking/modules/route53-dns-records"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  record_type_alias_config = [
    {
      name             = var.http_config.dns_record
      zone_id          = local.zone_id
      enable_www_cname = var.http_config.enable_www
      allow_overwrite  = true
      alias_target_config = {
        target_zone_id             = local.alb_zone_id
        target_dns_name            = local.alb_dns_name
        target_enable_health_check = true
      }
    }
  ]

  tags = local.tags

  depends_on = [
    data.aws_alb_target_group.tg_http,
    data.aws_alb_target_group.tg_https,
    data.aws_alb.this
  ]
}

// ***************************************
// 7. ALB listener rules
// ***************************************
locals {
  alb_http_listener_arn  = !local.is_https_redirection_enabled ? null : join("", [for listener in data.aws_lb_listener.http_listener : listener.arn])
  host_url_with_cname    = !local.is_https_redirection_enabled ? null : format("www.%s.%s", var.http_config.dns_record, var.http_config.domain)
  host_url_without_cname = !local.is_https_redirection_enabled ? null : format("%s.%s", var.http_config.dns_record, var.http_config.domain)
  #  host_url_with_explicit_http = !local.is_https_redirection_enabled ? null : format("http://%s.%s", var.http_config.dns_record, var.http_config.domain)
}

module "alb_listener_rule_always_redirect_to_https" {
  for_each   = !local.is_https_redirection_enabled ? {} : local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/alb-listener-rule?ref=v1.29.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  action_redirect_https = [
    {
      name                          = local.stack
      listener_arn                  = local.alb_http_listener_arn
      http_request_method_condition = ["GET", "HEAD"]
      host_header_condition         = [local.host_url_with_cname, local.host_url_without_cname]
      http_header_condition = {
        header = "X-Forwarded-Proto"
        values = ["http"]
      }
    }
  ]

  tags = local.tags

  depends_on = [
    data.aws_alb_target_group.tg_http,
    data.aws_alb_target_group.tg_https,
    data.aws_alb.this
  ]
}
