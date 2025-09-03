provider "aws" {
  region = "us-east-1"
}

module "webserver-cluster" {
  source = "C:/Users/ajala/Terraform-mod/modules/services/webserver-cluster"

  ami         = "ami-020cba7c55df1f615"
  server_text = "Checking and checking again and again For Zero Down-Time Deployment"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "ajsammy-bucket"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 3
  max_size           = 4
  enable_autoscaling = false
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
