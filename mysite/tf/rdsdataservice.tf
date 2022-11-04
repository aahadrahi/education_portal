# provider "postgresql" {
#   host = aws_rds_cluster.rds.endpoint
#   username = aws_rds_cluster.rds.master_username
#   password = aws_rds_cluster.rds.master_password
# }

# THIS WORKS:
# create role appuser with password '...' login inherit;
# create database appdb owner appuser;
# -- grant appuser to postgres;

# provider "rdsdataservice" {
#   region  = var.region
#   # profile = var.aws_profile
# }

# THIS DOESN'T WORK YET:
# resource "rdsdataservice_postgres_role" "app_db_role" {
#   name         = "appuser"
#   resource_arn = aws_rds_cluster.rds.arn
#   secret_arn   = aws_secretsmanager_secret.rds_master_credentials.arn
#   password     = random_password.app_db_password.result
#   login        = true
#   create_database = false
#   create_role  = false
#   inherit      = true
#   superuser    = false
# }

# THIS WORKS, BUT DEPENDS ON THE ROLE:
# resource "rdsdataservice_postgres_database" "appdb" {
#   name         = "appdb"
#   resource_arn = aws_rds_cluster.rds.arn
#   secret_arn   = aws_secretsmanager_secret.rds_master_credentials.arn
#   owner        = "appuser"
# }
