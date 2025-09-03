provider "aws" {
  region = "us-east-1"
}

module "webserver-cluster" {
  source = "git::ssh://git@github.com/samaj806/Terraform_module.git//services/webserver-cluster?ref=v0.2.1"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "ajsammy-bucket"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4

  custom_tags = {
    Owner     = "Team-Sam"
    ManagedBy = "terraform"
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale_out_during_business_hours"
  min_size               = 4
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver-cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale_in_at_night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.webserver-cluster.asg_name
}

# terraform {
#   backend "s3" {
#     bucket         = "ajsammy-bucket"
#     key            = "prod/services/webserver-cluster/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform_db-locks"
#     encrypt        = true
#   }
# }
