terraform {
    backend "s3" {
    bucket = "techieguy-vrush-tfm"
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

variable "environment" {
  default = "dev"
  type = string   #Optional field
}

variable "channel_name" {
  default = "vrush-tfm"
}
variable "region" {
  default = "us-east-1"
}

locals {
  bucket_name = "${var.channel_name}-bucket-${var.environment}-${var.region}"
  vpc_name = "${var.environment}-VPC"
}


# Create S3 bucket
resource "aws_s3_bucket" "sl-vrush-demo-bkt" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

resource "aws_vpc" "sample-vpc" {
  cidr_block = "10.0.2.0/24"
  region = var.region
  tags = {
    Environment = var.environment
    Name        = local.vpc_name
  }
}

resource "aws_instance" "sample-ec2" {
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  region = var.region


  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}

output "vpc_id" {
  value = aws_vpc.sample-vpc.id
}

output "ec_id" {
  value = aws_instance.sample-ec2.id
}