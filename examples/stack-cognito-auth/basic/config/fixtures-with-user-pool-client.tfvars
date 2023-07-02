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
    idp_identifiers = ["login.amazon.com"]
    attribute_mapping = {
      email = "email"
      name  = "name"
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
    idp_identifiers = ["accounts.google.com"]
    attribute_mapping = {
      email = "email"
      name  = "name"
    }
  }
]

user_pool_clients_config = [
  {
    client_name                          = "test-client"
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows                  = ["code", "implicit"]
    allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

    callback_urls           = ["https://app.example.com/login"]
    id_token_validity       = 2
    access_token_validity   = 2
    refresh_token_validity  = null
    enable_token_revocation = true
    token_validity_units = {
      id_token      = "hours"
      access_token  = "hours"
      refresh_token = null
    }
    auth_session_validity         = 4
    default_redirect_uri          = "https://app.example.com/dashboard"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH"]
    generate_secret               = false
    logout_urls                   = ["https://app.example.com/logout"]
    read_attributes               = ["email", "name"]
    supported_identity_providers  = ["COGNITO", "Google", "SignInWithApple"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["email", "name"]
  }
]
