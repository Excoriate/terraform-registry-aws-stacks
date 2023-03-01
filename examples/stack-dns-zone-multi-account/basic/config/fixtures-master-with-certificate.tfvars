aws_region = "us-east-1"
is_enabled = true

master_zone_config = {
  domain                 = "4id.network"
  target_env             = "master"
  environments_to_create = []
  enable_certificate     = true
}

environment = "master"
