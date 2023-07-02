aws_region     = "us-east-1"
is_enabled     = true
stack          = "test"
user_pool_name = "my-test-pool"

user_pool_ses_email_config = {
  domain         = "4id.network"
  from_email     = "tsn_test@4id.network"
  reply_to_email = "tsn_test@4id.network"
}

user_pool_domain_config = {
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  domain          = "4id.network"
}
