module "master_hosted_zone" {
  count      = !local.is_master_config_enabled ? 0 : 1
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = local.is_master_config_enabled

  // Specific configuration for 'master' account.
  hosted_zone_stand_alone = [
    {
      name          = var.master_zone_config.domain
      comment       = "Master account domain configuration."
      force_destroy = local.is_master_unprotected_for_destroy
    }
  ]

  hosted_zone_stand_alone_name_servers = !local.is_master_environment_ns_records_enabled ? [] : [
    for envs in var.master_zone_config.environments_to_create : {
      hosted_zone_name = trimspace(var.master_zone_config.domain)
      record_name      = format("%s.%s", trimspace(envs.name), trimspace(var.master_zone_config.domain))
      name_servers     = envs.name_servers
      ttl              = envs.ttl
    }
  ]
}

module "master_certificate" {
  count      = !local.is_master_tls_certificate_enabled ? 0 : 1
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = local.is_master_tls_certificate_enabled

  // Specific configuration for 'master' account.
  acm_certificate_config = [
    {
      name                        = "master-acm-certificate"
      domain_name                 = var.master_zone_config.domain
      wait_for_certificate_issued = true
      subject_alternative_names   = [format("*.%s", var.master_zone_config.domain)]
    }
  ]

  depends_on = [
    module.master_hosted_zone
  ]
}

module "envs_hosted_zones" {
  for_each   = local.envs_to_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  hosted_zone_subdomains_parent = each.value["hosted_zone_subdomains_parent"]
  hosted_zone_subdomains_childs = each.value["hosted_zone_subdomains_childs"]
}

module "envs_certificates" {
  for_each   = local.tsl_certs_per_subdomain
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = each.value["is_enabled"]

  acm_certificate_config = [
    {
      name                        = format("%s-acm-certificate", each.value["subdomain"])
      domain_name                 = each.value["subdomain"]
      wait_for_certificate_issued = true
      subject_alternative_names   = [format("*.%s", each.value["subdomain"])]
    }
  ]

  depends_on = [
    module.envs_hosted_zones
  ]
}

module "envs_certificates_per_zone" {
  for_each   = { for k, v in local.tsl_certs_per_subdomain : k => v if length(v["child_zones"]) > 0 }
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = each.value["is_enabled"]

  acm_certificate_config = [
    for zone in each.value["child_zones"] : {
      name                        = format("%s-acm-certificate", zone["subdomain_full"])
      domain_name                 = zone["subdomain_full"]
      wait_for_certificate_issued = true
      subject_alternative_names   = [format("*.%s", zone["subdomain_full"])]
    }
  ]

  depends_on = [
    module.envs_hosted_zones,
    module.envs_certificates
  ]
}
