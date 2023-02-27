module "master_hosted_zone" {
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.8.0"
  aws_region = var.aws_region
  is_enabled = local.is_master_config_enabled

  // Specific configuration for 'master' account.
  hosted_zone_stand_alone = [
    {
      name          = lookup(local.master_config_normalised, "domain", null)
      comment       = "Master account domain configuration."
      force_destroy = lookup(local.master_config_normalised, "force_destroy", false)
    }
  ]

  hosted_zone_stand_alone_name_servers = lookup(local.master_config_normalised, "environments", [])
}

module "master_certificate" {
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/acm-certificate?ref=v1.7.0"
  aws_region = var.aws_region
  is_enabled = local.master_certificate_is_enabled

  // Specific configuration for 'master' account.
  acm_certificate_config = [
    {
      name                        = "master-acm-certificate"
      domain_name                 = lookup(local.master_config_normalised, "domain", null)
      wait_for_certificate_issued = true
    }
  ]

  depends_on = [
    module.master_hosted_zone
  ]
}

module "envs_hosted_zones" {
  for_each   = local.envs_to_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.7.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  hosted_zone_subdomains_parent = each.value["hosted_zone_subdomains_parent"]
  hosted_zone_subdomains_childs = each.value["hosted_zone_subdomains_childs"]
}
