output app_endpoint {
  value = aws_apigatewayv2_api.apigw.api_endpoint
}

output static_bucket {
  value = local.static_bucket
}

output static_url {
  value = local.static_url
}

output rds_master_credentials_arn {
  value = aws_secretsmanager_secret.rds_master_credentials.arn
}

output init_superuser_password {
  value = random_password.init_superuser_password.result
  sensitive = true
}
