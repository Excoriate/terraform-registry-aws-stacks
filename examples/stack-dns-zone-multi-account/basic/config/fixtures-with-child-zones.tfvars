aws_region = "us-east-1"
is_enabled = true

environments_config = [
  {
    subdomain  = "dev.example.com"
    target_env = "dev"
    child_zones = [
      {
        name : "api"
        ttl = 300
      },
      {
        name : "web"
        ttl = 300
      }
    ]
  },
  {
    subdomain  = "stage.example.com"
    target_env = "stage"
    child_zones = [
      {
        name : "api"
        ttl = 300
      },
      {
        name : "web"
        ttl = 300
      }
    ]
  }
]

environment = "stage"
