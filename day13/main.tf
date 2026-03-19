# Declare Data source for VPC, subnet and AWS AMI

data "aws_vpc" "vpc_vrush" {
  filter {
    name = "tag:Name"
    values = ["default"]
  }
}

data aws_subnet "subnet_vrush" {
filter {
  name = "tag:Name"
  values = ["subnet-a"]
}

vpc_id = data.aws_vpc.vpc_vrush.id
}

data "aws_ami" "amazon_linux_2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


# AWS EC2 resource creation

resource "aws_instance" "ec2_test" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.subnet_vrush.id

  tags = {
        Name = "Application Server EC2"
  }
}
