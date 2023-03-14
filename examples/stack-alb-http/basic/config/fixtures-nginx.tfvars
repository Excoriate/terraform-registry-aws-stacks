aws_region = "us-east-1"
is_enabled = true

// Subnets tsn-sandbox-us-east-1-network-core-cross-vpc-backbone-public-us-east-1b
vpc_name = "tsn-sandbox-us-east-1-network-core-cross-vpc-backbone"
stack    = "test"

// HTTP configuration
http_config = {
  enable_http                        = true
  enable_https                       = true
  domain                             = "sandbox.4id.network"
  dns_record                         = "test-app"
  enable_www                         = true
  enable_forced_redirection_to_https = true
}
