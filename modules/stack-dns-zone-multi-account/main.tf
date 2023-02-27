module "dns_zone_master" {
  count      = local.master_account_enable_config ? 1 : 0
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.7.0"
  aws_region = var.aws_region
  is_enabled = local.master_account_enable_config

  // Specific configuration for 'master' account.
  hosted_zone_stand_alone = [
    {
      name          = var.master_account_config.domain
      comment       = "Master account domain configuration."
      force_destroy = false
    }
  ]

  hosted_zone_stand_alone_name_servers = [
    for envs in var.master_account_config.environments_to_create : {
      hosted_zone_name = var.master_account_config.domain
      record_name      = format("%s.%s", envs.name, var.master_account_config.domain)
      name_servers     = envs.name_servers
      ttl              = envs.ttl
    }
  ]
}

module "dns_environments" {
  for_each   = local.envs_to_create
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/route53-hosted-zone?ref=v1.7.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  hosted_zone_subdomains_parent = each.value["hosted_zone_subdomains_parent"]
  hosted_zone_subdomains_childs = each.value["hosted_zone_subdomains_childs"]
}
