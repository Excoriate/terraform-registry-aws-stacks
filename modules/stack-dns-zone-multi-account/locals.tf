locals {
  aws_region_to_deploy = var.aws_region

  //1. Enable master 'hosted zone' creation
  is_master_config_enabled                 = !var.is_enabled ? false : var.master_zone_config == null ? false : lower(trimspace(var.master_zone_config.target_env)) == lower(trimspace(var.environment))
  is_master_tls_certificate_enabled        = !local.is_master_config_enabled ? false : var.master_zone_config.enable_certificate
  is_master_environment_ns_records_enabled = !local.is_master_config_enabled ? false : var.master_zone_config.environments_to_create == null ? false : length(var.master_zone_config.environments_to_create) > 0
  is_master_unprotected_for_destroy        = !local.is_master_config_enabled ? false : length(var.environments_to_protect_from_destroy) == 0 ? true : !contains(var.environments_to_protect_from_destroy, var.environment)

  //2. Child environments.
  is_envs_config_enabled = !var.is_enabled ? false : var.environment_zones_config == null ? false : length(var.environment_zones_config) > 0
  envs_normalized = !local.is_envs_config_enabled ? [] : [
    for env in var.environment_zones_config : {
      target_env                  = env.target_env
      enable_certificate          = env["enable_certificate"] == null ? false : env["enable_certificate"]
      enable_certificate_per_zone = env["enable_certificate_per_zone"] == null ? false : env["enable_certificate_per_zone"]
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

      enable_certificate          = env["enable_certificate"]
      enable_certificate_per_zone = env["enable_certificate_per_zone"]

      hosted_zone_subdomains_childs = [
        for zone in env["zones_config"] : {
          domain            = lookup(env["subdomain_config"], "name")
          name              = zone["name"]
          comment           = format("Hosted zone for %s environment", env["target_env"])
          force_destroy     = lookup(zone, "force_destroy")
          ttl               = lookup(zone, "ttl")
          delegation_set_id = null
        }
      ]
    }
  }

  // It only filters the subdomains that are marked as 'certificate' compatibles.
  tsl_certs_per_subdomain = !local.is_envs_config_enabled ? {} : {
    for k, v in local.envs_to_create : k => {
      subdomain  = v["hosted_zone_subdomains_parent"]["name"]
      is_enabled = true
    } if v["enable_certificate"]
  }

  tsl_certs_per_child_zone = !local.is_envs_config_enabled ? {} : {
    for k, v in local.envs_to_create : k => {
      subdomain  = v["hosted_zone_subdomains_parent"]["name"]
      is_enabled = true
      child_zones = [
        for zone in v["hosted_zone_subdomains_childs"] : {
          domain         = v["hosted_zone_subdomains_parent"]["name"]
          subdomain      = zone["name"]
          subdomain_full = format("%s.%s", zone["name"], v["hosted_zone_subdomains_parent"]["name"])
          is_enabled     = true
        }
      ]
    } if v["enable_certificate_per_zone"]
  }
}
