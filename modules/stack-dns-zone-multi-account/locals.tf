locals {
  aws_region_to_deploy = var.aws_region

  //1. Enable master 'hosted zone' creation
  master_account_enable_config = !var.is_enabled ? false : var.master_account_config != null && var.master_account_config.target_env == var.environment

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
          force_destroy = zone.target_env == "prod" ? false : true
          ttl           = zone.ttl
        }
      ]
    } if lower(trimspace(env.target_env)) == lower(trimspace(var.environment))
  ]

  envs_to_create = !local.is_envs_config_enabled ? {} : {
    for env in local.envs_normalized : env["subdomain_config"]["name"] => {
      hosted_zone_subdomains_parent = {
        parent_zone_name  = lookup(env["subdomain_config"], "name")
        comment           = format("Hosted zone for %s environment", env["target_env"])
        force_destroy     = lookup(env["subdomain_config"], "force_destroy")
        delegation_set_id = null
      }

      hosted_zone_subdomains_childs = [
        for zone in env["zones_config"] : {
          domain            = lookup(env["subdomain_config"], "name")
          name              = lookup(zone, "name")
          comment           = format("Hosted zone for %s environment", env["target_env"])
          force_destroy     = lookup(zone, "force_destroy")
          ttl               = lookup(zone, "ttl")
          delegation_set_id = null
        }
      ]
    }
  }
}
