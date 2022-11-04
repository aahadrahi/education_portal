resource aws_apigatewayv2_api apigw {
  name = "${var.name_prefix}_apigw"
  protocol_type = "HTTP"

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_apigatewayv2_integration integration {
  api_id = aws_apigatewayv2_api.apigw.id
  integration_type = "AWS_PROXY"

  connection_type = "INTERNET"
  // content_handling_strategy = "CONVERT_TO_TEXT"
  // description               = "Lambda example"
  integration_method = "POST"
  integration_uri = aws_lambda_function.wsgi.arn
  passthrough_behavior = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource aws_apigatewayv2_route route {
  api_id = aws_apigatewayv2_api.apigw.id
  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource aws_apigatewayv2_stage default {
  api_id = aws_apigatewayv2_api.apigw.id
  name = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.log_group.arn
    format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  }

  tags = {
    Environment = var.environment_tag
  }
}
