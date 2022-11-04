[optional]
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

1. docker build -t django_image .
make upload-static
DOCKER_BUILDKIT=1 docker build -o out -f lambda.dockerfile .
aws secretsmanager delete-secret --secret-id your-secret-name --force-delete-without-recovery --region your-region
aws secretsmanager delete-secret --secret-id educationportal_rds_app_credentials --force-delete-without-recovery --region ap-south-1 --profile django

