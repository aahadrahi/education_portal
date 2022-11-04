resource aws_iam_role lambda_role {
  name = "${var.name_prefix}_lambda_role"
  path = "/service-role/"

  tags = {
    Environment = var.environment_tag
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource aws_iam_policy xray_policy {
  name = "${var.name_prefix}_xray_policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource aws_iam_role_policy_attachment AWSLambdaBasicExecutionRole {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource aws_iam_role_policy_attachment xray_policy {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.xray_policy.arn
}

resource aws_iam_role_policy_attachment AWSLambdaVPCAccessExecutionRole {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource aws_iam_user smtp_user {
  name = "${var.name_prefix}_smtp_user"
  path = "/system/"

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_iam_user_policy smtp_user_policy {
  name = "${var.name_prefix}_smtp_user_policy"
  user = aws_iam_user.smtp_user.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendRawEmail",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource aws_iam_access_key smtp_user {
  # This resource causes an access key to be generated.
  # It also generates and stores an SMTP password.
  user = aws_iam_user.smtp_user.name
}
