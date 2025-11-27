terraform {
    backend "s3" {
    bucket = "techieguy-vrush"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "sl-vrush-demo-bkt" {
  bucket = "vrush-tf-test-bkt"

  tags = {
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}
