provider "aws" {
  region = "us-east-1"
}

module "webserver-cluster" {
  source = "C:/Users/samue/Downloads/AWS/Terraform_Git/Terraform_module/services/webserver-cluster"

  ami         = "ami-020cba7c55df1f615"
  server_text = "Checking and checking again and again For Zero Down-Time Deployment"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "ajsammy-bucket012"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type      = "t3.micro"
  min_size           = 2
  max_size           = 4
  enable_autoscaling = false
}

