resource aws_db_subnet_group subnet_group {
  name = "${var.name_prefix}_subnet_group"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

  tags = {
    Environment = var.environment_tag
  }
}

resource aws_rds_cluster rds {
  cluster_identifier      = "${var.name_prefix}-rds"
  engine                  = "aurora-postgresql"
#  availability_zones      = ["${var.region}a", "${var.region}b"]
  master_username         = "postgres"
  master_password         = random_password.master_password.result
  apply_immediately       = true
  engine_mode             = "serverless"
  deletion_protection     = true
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  enable_http_endpoint    = true

  scaling_configuration {
    auto_pause            = true
    min_capacity          = 2
    max_capacity          = 4
    seconds_until_auto_pause = 300
  }

  tags = {
    Environment = var.environment_tag
  }
}
