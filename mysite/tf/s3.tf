resource random_id bucket_id {
  byte_length  = 8
}

resource aws_s3_bucket code {
  bucket = "${var.name_prefix}-${random_id.bucket_id.hex}-code"
  tags = {
    Environment = var.environment_tag
  }
}

resource aws_s3_bucket_public_access_block code_not_public {
  bucket = aws_s3_bucket.code.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource aws_s3_bucket_object lambda_zip {
  bucket = aws_s3_bucket.code.bucket
  key    = "lambda-${filemd5("../out/lambda.zip")}.zip"
  source = "../out/lambda.zip"
}

resource aws_s3_bucket media {
  bucket = "${var.name_prefix}-${random_id.bucket_id.hex}-media"
  tags = {
    Environment = var.environment_tag
  }
}

resource aws_s3_bucket_public_access_block media_not_public {
  bucket = aws_s3_bucket.media.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

locals {
  static_bucket = "${var.name_prefix}-${random_id.bucket_id.hex}-static"
  static_url = "https://${aws_cloudfront_distribution.cf_static.domain_name}/s/"
}

resource aws_s3_bucket static {
  bucket = local.static_bucket
  acl = "private"

  tags = {
    Environment = var.environment_tag
  }

  website {
    index_document = "index.html"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${local.static_bucket}/*"
      ]
    }
  ]
}
POLICY
}

resource aws_s3_bucket_public_access_block static_public {
  bucket = aws_s3_bucket.static.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "static_index_html" {
  bucket = aws_s3_bucket.static.bucket
  key    = "index.html"
  content = "<html><body><a href=\"${aws_apigatewayv2_api.apigw.api_endpoint}\">Home</a></body></html>"
  content_type = "text/html"
}
