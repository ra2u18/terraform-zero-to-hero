provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/ra2u18/tf-modules-test//services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "tf-state-bucket-rick"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro" # usually have sth m4-large
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
  }
}

