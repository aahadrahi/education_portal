locals {
  lambda_env_vars = {
    "ENV_SECRET_ID" = aws_secretsmanager_secret.env_secret.arn
    "DJANGO_SETTINGS_MODULE" = "mysite.settings.production"
    "DJANGO_DB_ENGINE" = "django.db.backends.postgresql_psycopg2"
    "DJANGO_DB_NAME" = "appdb"
    "DJANGO_DB_USER" = "appuser"
    # DJANGO_DB_PASSWORD is in the env secret
    "DJANGO_DB_HOST" = aws_rds_cluster.rds.endpoint
    "DJANGO_DB_PORT" = aws_rds_cluster.rds.port
    "ALLOWED_HOSTS" = aws_apigatewayv2_api.apigw.api_endpoint
    "STATIC_URL" = local.static_url
    "DEFAULT_FROM_EMAIL" = var.default_from_email
    "EMAIL_HOST" = "email-smtp.${var.region}.amazonaws.com"
    "EMAIL_HOST_USER" = aws_iam_access_key.smtp_user.id
    # EMAIL_HOST_PASSWORD is in the env secret
    # The DJANGO_SUPERUSER_* env vars are used when running createsuperuser.
    "DJANGO_SUPERUSER_USERNAME" = "admin"
    "DJANGO_SUPERUSER_EMAIL" = var.default_from_email
  }
}

resource aws_lambda_function wsgi {
  function_name = "${var.name_prefix}_wsgi"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  s3_bucket = aws_s3_bucket_object.lambda_zip.bucket
  s3_key = aws_s3_bucket_object.lambda_zip.key
  s3_object_version = aws_s3_bucket_object.lambda_zip.version_id
  memory_size = "256"
  publish = false
  timeout = "180"
  runtime = "python3.8"

  environment {
    variables = local.lambda_env_vars
  }

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_lambda_permission wsgi_perm {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.wsgi.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.apigw.execution_arn}/*/${aws_apigatewayv2_stage.default.name}"
}

resource aws_lambda_function manage {
  function_name = "${var.name_prefix}_manage"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.manage"
  s3_bucket = aws_s3_bucket_object.lambda_zip.bucket
  s3_key = aws_s3_bucket_object.lambda_zip.key
  s3_object_version = aws_s3_bucket_object.lambda_zip.version_id
  memory_size = "512"
  publish = false
  timeout = "90"
  runtime = "python3.8"

  environment {
    variables = local.lambda_env_vars
  }

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_lambda_function hello {
  function_name = "${var.name_prefix}_hello"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.hello"
  s3_bucket = aws_s3_bucket_object.lambda_zip.bucket
  s3_key = aws_s3_bucket_object.lambda_zip.key
  s3_object_version = aws_s3_bucket_object.lambda_zip.version_id
  memory_size = "256"
  publish = false
  timeout = "5"
  runtime = "python3.8"

  environment {
    variables = local.lambda_env_vars
  }

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Environment = var.environment_tag
  }
}
