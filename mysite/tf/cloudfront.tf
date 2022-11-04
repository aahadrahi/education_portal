resource aws_cloudfront_cache_policy static_cache_policy {
  name = "${var.name_prefix}_cf_cache_policy"
  min_ttl = 1
  default_ttl = 30
  max_ttl = 30

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource aws_cloudfront_distribution cf_static {
  enabled = true
  price_class = "PriceClass_100"
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    origin_id = "S3-${local.static_bucket}"
    domain_name = aws_s3_bucket.static.website_endpoint

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-${local.static_bucket}"
    cache_policy_id = aws_cloudfront_cache_policy.static_cache_policy.id
    viewer_protocol_policy = "https-only"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = var.environment_tag
  }
}
