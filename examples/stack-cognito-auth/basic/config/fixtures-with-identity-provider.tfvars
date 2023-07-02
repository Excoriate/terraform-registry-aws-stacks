aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

user_pool_ses_email_config = {
  domain         = "4id.network"
  from_email     = "tsn_test@4id.network"
  reply_to_email = "tsn_test@4id.network"
}

identity_provider_config = [
  {
    idp_name      = "LoginWithAmazon",
    provider_name = "LoginWithAmazon"
    provider_type = "LoginWithAmazon"
    provider_details = {
      client_id        = "client_id"
      client_secret    = "client_secret"
      authorize_scopes = "email, profile, openid" # Added authorize_scopes
    }
  },
  {
    idp_name      = "Facebook",
    provider_name = "Google"
    provider_type = "Google"
    provider_details = {
      client_id        = "client_id"
      client_secret    = "client_secret"
      authorize_scopes = "email, profile, openid" # Added authorize_scopes
    }
  }
]
