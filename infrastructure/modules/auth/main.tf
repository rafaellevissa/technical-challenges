resource "aws_cognito_user_pool" "pool" {
  name = "app-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "app-client"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  generate_secret                      = false
  allowed_oauth_flows                  = ["code", "implicit"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://app.exemplo.com"]
}

output "user_pool_id" { value = aws_cognito_user_pool.pool.id }
output "client_id" { value = aws_cognito_user_pool_client.client.id }
