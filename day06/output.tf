output "vpc_id" {
  value = aws_vpc.sample-vpc.id
}

output "ec_id" {
  value = aws_instance.sample-ec2.id
}