resource random_password django_secret_key {
  length  = 64
  special = false
}

resource random_password init_superuser_password {
  length  = 16
  special = true
}

resource random_password master_password {
  length  = 32
  special = false
}

resource random_password app_db_password {
  length  = 32
  special = false
}

resource aws_secretsmanager_secret env_secret {
  name = "${var.name_prefix}_env_secret"
  recovery_window_in_days = 30

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_secretsmanager_secret_policy env_secret {
  secret_arn = aws_secretsmanager_secret.env_secret.arn
  policy = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Principal" : {
      "AWS" : "${aws_iam_role.lambda_role.arn}"
    },
    "Action" : [ "secretsmanager:GetSecretValue" ],
    "Resource" : "*"
  } ]
}
POLICY
}

resource aws_secretsmanager_secret_version env_secret {
  secret_id = aws_secretsmanager_secret.env_secret.id
  secret_string = jsonencode({
    "DJANGO_SECRET_KEY": random_password.django_secret_key.result
    "DJANGO_DB_PASSWORD": random_password.app_db_password.result
    "EMAIL_HOST_PASSWORD": aws_iam_access_key.smtp_user.ses_smtp_password_v4
    "DJANGO_SUPERUSER_PASSWORD": random_password.init_superuser_password.result
  })
}

resource aws_secretsmanager_secret rds_master_credentials {
  name = "${var.name_prefix}_rds_master_credentials"
  tags = {
    Environment = var.environment_tag
  }
}

resource aws_secretsmanager_secret_version rds_master_credentials {
  secret_id = aws_secretsmanager_secret.rds_master_credentials.id
  secret_string = jsonencode({
    "dbInstanceIdentifier" = aws_rds_cluster.rds.cluster_identifier
    "engine" = aws_rds_cluster.rds.engine
    "host" = aws_rds_cluster.rds.endpoint
    "port" = aws_rds_cluster.rds.port
    "resourceId" = aws_rds_cluster.rds.cluster_resource_id
    "username" = aws_rds_cluster.rds.master_username
    "password" = aws_rds_cluster.rds.master_password
  })
}

resource aws_secretsmanager_secret rds_app_credentials {
  name = "${var.name_prefix}_rds_app_credentials"
  tags = {
    Environment = var.environment_tag
  }
}

resource aws_secretsmanager_secret_version rds_app_credentials {
  secret_id = aws_secretsmanager_secret.rds_app_credentials.id
  secret_string = jsonencode({
    "dbInstanceIdentifier" = aws_rds_cluster.rds.cluster_identifier
    "engine" = aws_rds_cluster.rds.engine
    "host" = aws_rds_cluster.rds.endpoint
    "port" = aws_rds_cluster.rds.port
    "resourceId" = aws_rds_cluster.rds.cluster_resource_id
    "username" = "appuser"
    "password" = random_password.app_db_password.result
  })
}
