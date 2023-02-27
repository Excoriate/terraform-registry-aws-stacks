locals {
  aws_region_to_deploy = var.aws_region

  //1. Enable master 'hosted zone' creation
  is_master_config_enabled = !var.is_enabled ? false : var.master_account_config == null ? false : lower(trimspace(var.master_account_config.target_env)) == lower(trimspace(var.environment))

  master_config_normalised = !local.master_config_normalised ? {} : {
    name               = trimspace(var.master_account_config.domain)
    target_env         = trimspace(var.master_account_config.target_env)
    force_destroy      = length(var.environments_to_protect_from_destroy) == 0 ? true : contains(var.environments_to_protect_from_destroy, lookup(var.master_account_config, "target_env")) ? false : true
    enable_certificate = var.master_account_config.enable_certificate
    environments = [
      for envs in var.master_account_config.environments_to_create : {
        hosted_zone_name = trimspace(var.master_account_config.domain)
        record_name      = format("%s.%s", trimspace(envs.name), trimspace(var.master_account_config.domain))
        name_servers     = envs.name_servers
        ttl              = envs.ttl
      }
    ]
  }

  master_certificate_is_enabled = !local.master_certificate_is_enabled ? false : var.master_account_config.enable_certificate

  // 1.1 Enable certificate for the master account.


  //2. Child environments.
  is_envs_config_enabled = !var.is_enabled ? false : var.environments_config == null ? false : length(var.environments_config) > 0
  envs_normalized = !local.is_envs_config_enabled ? [] : [
    for env in var.environments_config : {
      target_env = env.target_env
      subdomain_config = {
        name          = env.subdomain
        force_destroy = env.target_env == "prod" ? false : true
      }

      zones_config = [
        for zone in env.child_zones : {
          name          = zone.name
          force_destroy = env.target_env == "prod" ? false : true
          ttl           = zone.ttl
        }
      ]
    } if lower(trimspace(env.target_env)) == lower(trimspace(var.environment))
  ]

  envs_to_create = !local.is_envs_config_enabled ? {} : {
    for env in local.envs_normalized : env["subdomain_config"]["name"] => {
      hosted_zone_subdomains_parent = {
        name              = lookup(env["subdomain_config"], "name")
        comment           = format("Hosted zone for %s environment", env["target_env"])
        force_destroy     = lookup(env["subdomain_config"], "force_destroy")
        delegation_set_id = null
      }

      hosted_zone_subdomains_childs = [
        for zone in env["zones_config"] : {
          domain = lookup(env["subdomain_config"], "name")
          #          name              = format("%s.%s", zone["name"], lookup(env["subdomain_config"], "name"))
          name              = zone["name"]
          comment           = format("Hosted zone for %s environment", env["target_env"])
          force_destroy     = lookup(zone, "force_destroy")
          ttl               = lookup(zone, "ttl")
          delegation_set_id = null
        }
      ]
    }
  }
}
