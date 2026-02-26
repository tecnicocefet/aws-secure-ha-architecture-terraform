terraform {
  required_version = "~> 1.6.0"

  backend "s3" {
    bucket         = "joaocarlos-remote-state"
    key            = "labs/arquitetura-completa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}