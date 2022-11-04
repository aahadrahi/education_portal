resource aws_cloudwatch_log_group log_group {
  name = "${var.name_prefix}_log_group"

  tags = {
    Environment = var.environment_tag
  }
}
