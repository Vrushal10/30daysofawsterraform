terraform {
  backend "s3" {
    bucket = "techieguy-vrush-tfm-1006"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}