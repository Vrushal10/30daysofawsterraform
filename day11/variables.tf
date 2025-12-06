variable "project_name"{
  default = "Project SIGMA Resource"
} 

variable "default-tags" {
  default = {
    company = "ABC-Corp"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  default = {
    environment = "production"
    cost_center = "12345-tf"
  }
}

variable "bucket_name" {
  default = "SigmaProjectS3BucketinTerraform with CAPS and spaces!!"
}

variable "allowed_ports" {
  default = "80, 443, 8443, 9090, 9091"
}


variable "instance_sizes" {
  default = {
    dev = "t2.micro"
    staging = "t3.small"
    prod = "t3.large"
  }
}

variable "environment" {
  default = "dev"
}