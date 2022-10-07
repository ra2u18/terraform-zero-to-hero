provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source =  "github.com/ra2u18/tf-modules-test//services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "tf-state-bucket-rick"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro" # usually have sth m4-large
  min_size      = 2
  max_size      = 10

  custom_tags = {
    Owner = "team-foo"
    ManagedBy = "terraform"
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_bussiness_hours" {
  scheduled_action_name = "scale-out-during-bussiness-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale-in-at-night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}
