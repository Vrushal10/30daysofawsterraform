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

