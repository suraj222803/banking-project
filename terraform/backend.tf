terraform {
  backend "s3" {
    bucket         = "banking-terraform-state-2000"
    key            = "banking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
