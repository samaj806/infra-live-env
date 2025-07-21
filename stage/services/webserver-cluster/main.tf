provider "aws" {
  region = "us-east-1"
}

module "webserver-cluster" {
  source =  "git::ssh://git@github.com/samaj806/Terraform_module.git//services/webserver-cluster?ref=v0.1.0"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "ajsammy-bucket"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 2
}

# terraform {
#   backend "s3" {
#     bucket         = "ajsammy-bucket"
#     key            = "stage/services/webserver-cluster/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform_db-locks"
#     encrypt        = true
#   }
# }