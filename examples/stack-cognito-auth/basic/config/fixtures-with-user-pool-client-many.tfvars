aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

user_pool_ses_email_config = {
  domain         = "4id.network"
  from_email     = "tsn_test@4id.network"
  reply_to_email = "tsn_test@4id.network"
}

user_pool_mfa_configuration_config = {
  enable_mfa  = false
  disable_mfa = false
}

user_pool_account_recovery_config = null

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
  #  {
  #    idp_name      = "SignInWithApple",
  #    provider_name = "SignInWithApple"
  #    provider_type = "SignInWithApple"
  #    provider_details = {
  #      client_id        = "client_id"
  #      team_id          = "team_id"
  #      key_id           = "key_id"
  #      "private_key"   = "-----BEGIN PRIVATE KEY-----\nYOUR_FAKE_PRIVATE_KEY\n-----END PRIVATE KEY-----"
  #      authorize_scopes = "email,name"
  #    }
  #    idp_identifiers = ["appleid.apple.com"]
  #    attribute_mapping = {
  #      email = "email"
  #      name  = "name"
  #    }
  #  },
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
    client_name                          = "client-app-1"
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows                  = ["code"]
    allowed_oauth_scopes                 = ["email", "openid"]
    callback_urls                        = ["https://app1.example.com/login", "https://app1.example.com/landing"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = null
    enable_token_revocation              = true
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = null
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app1.example.com/landing"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH"]
    generate_secret               = false
    logout_urls                   = ["https://app1.example.com/logout"]
    read_attributes               = ["email"]
    supported_identity_providers  = ["COGNITO"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["email"]
  },
  {
    client_name                          = "client-app-2"
    allowed_oauth_flows_user_pool_client = false
    allowed_oauth_flows                  = ["implicit"]
    allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
    callback_urls                        = ["https://app2.example.com/login", "https://app2.example.com/dashboard"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = 2
    enable_token_revocation              = false
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = "days"
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app2.example.com/dashboard"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH", "CUSTOM_AUTH_FLOW_ONLY"]
    generate_secret               = false
    logout_urls                   = ["https://app2.example.com/logout"]
    read_attributes               = ["email"]
    supported_identity_providers  = ["Google"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["phone_number"]
  },
  {
    client_name                          = "client-app-3"
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows                  = ["code", "implicit"]
    allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin"]
    callback_urls                        = ["https://app3.example.com/login", "https://app3.example.com/dashboard"]
    id_token_validity                    = 1
    access_token_validity                = 1
    refresh_token_validity               = null
    enable_token_revocation              = true
    token_validity_units = {
      id_token      = "days"
      access_token  = "days"
      refresh_token = null
    }
    auth_session_validity         = 3
    default_redirect_uri          = "https://app3.example.com/dashboard"
    explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH"]
    generate_secret               = true
    logout_urls                   = ["https://app3.example.com/logout"]
    read_attributes               = ["email", "name"],
    supported_identity_providers  = ["Google"]
    prevent_user_existence_errors = "ENABLED"
    write_attributes              = ["email", "name"]
  }
]
