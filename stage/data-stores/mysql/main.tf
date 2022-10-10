terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket = "tf-state-bucket-rick"
  #   key    = "prod/data-stores/mysql/terraform.tfstate"
  #   region = "us-east-2"
  #
  #   dynamodb_table = "tf-state-table-lock-rick"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-2"
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  db_name     = "stage_db"
  db_username = var.db_username
  db_password = var.db_password
}
