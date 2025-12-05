variable "environment" {
  default = "dev"
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_count" {
  description = "Number of EC2 instances to be created"
  type = number
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring for EC2 instance"
  type = bool
  default = true
}

variable "associate_public_ip_address" {
  type = bool
  default = true
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = list(string)
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

variable "allowed_vm_type" {
  description = "List of allowed VM types"
  type = list(string)
  default = [ "t2.micro", "t2.small", "t3.micro", "t3.small" ]
}

variable "allowed_region" {
  description = "List of allowed region"
  type = set(string)
  default = [ "us-east-1", "us-west-2", "eu-west-1", "eu-west-1" ]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-instance"
    created_by  = "terraform"
    Compliance = "yes"
  }
}

variable "ingress_values" {
  type = tuple([ number, string, number ])
  default = [ 443, "tcp", 443 ]
}

variable "config" {
  type = object({
    region = string,
    monitoring = bool,
    instance_count = number
  })
  default = {
    region = "us-east-1",
    monitoring = true,
    instance_count = 1
  }
}


variable "bucket_names" {
  description = "List of bucket names"
  type = list(string)
  default = [ "my-unique-bucket-day08-4545", "my-unique-bucket-day08-4556" ]
}


variable "bucket_name_set" {
  description = "List of bucket names"
  type = set(string)
  default = [ "my-unique-bucket-day08-5678", "my-unique-bucket-day08-3456" ]
}


variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]
}