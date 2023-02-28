aws_region = "us-east-1"
is_enabled = true

master_zone_config = {
  domain                 = "example.com"
  target_env             = "master"
  environments_to_create = []
}

environment = "master"
