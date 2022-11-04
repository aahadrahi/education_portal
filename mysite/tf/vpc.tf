resource aws_vpc vpc {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}_vpc"
    Environment = var.environment_tag
  }
}

resource aws_route_table main_rt {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name_prefix}_main_rt"
    Environment = var.environment_tag
  }
}

resource aws_main_route_table_association main_rt_assoc {
  vpc_id = aws_vpc.vpc.id
  route_table_id = aws_route_table.main_rt.id
}

resource aws_route_table subnet_rt {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name_prefix}_subnet_rt"
    Environment = var.environment_tag
  }
}

resource aws_subnet a {
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 1)
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.name_prefix}_subnet_a"
    Environment = var.environment_tag
  }
}

resource aws_route_table_association a {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.subnet_rt.id
}

resource aws_subnet b {
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 2)
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.name_prefix}_subnet_b"
    Environment = var.environment_tag
  }
}

resource aws_route_table_association b {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.subnet_rt.id
}

resource aws_vpc_endpoint secretsmanager {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
  auto_accept = true

  tags = {
    Name = "${var.name_prefix}_vpce_secretsmanager"
    Environment = var.environment_tag
  }
}

resource aws_vpc_endpoint email_smtp {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.email-smtp"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
  auto_accept = true

  tags = {
    Name = "${var.name_prefix}_vpce_email_smtp"
    Environment = var.environment_tag
  }
}
