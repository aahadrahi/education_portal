terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 3.0"
    }

    # rdsdataservice = {
    #   source = "awsiv/rdsdataservice"
    # }
  }
}

# Configure the AWS Provider
provider aws {
  region = var.region
  access_key = "AKIAREQSY5EYQ6LSPDPY"
  secret_key = "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"
  # shared_credentials_file = "/Users/tf_user/.aws/creds"
  # profile                 = "django"
}
