terraform {
  backend "s3" {
    bucket = "devopsengineer2-terraform"
    key    = "tools/terraform.tfstate"
    region = "us-east-1"
  }
}