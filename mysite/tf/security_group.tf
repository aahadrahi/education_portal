resource aws_security_group lambda_sg {
  name = "${var.name_prefix}_lambda_sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment_tag
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource aws_security_group rds_sg {
  name = "${var.name_prefix}_rds_sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment_tag
  }

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource aws_security_group vpce_sg {
  name = "${var.name_prefix}_vpce_sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment_tag
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }
}
