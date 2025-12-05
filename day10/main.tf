# ==============================================================================
# EXAMPLE 1: CONDITIONAL EXPRESSIONS
# ==============================================================================

resource "aws_instance" "tf-vrush-instance" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
#   instance_type = "t3.micro"

  instance_type = var.environment=="dev" ? "t2.micro" : "t3.micro"

  tags = var.tags

}


# ==============================================================================
# EXAMPLE 2: DYNAMIC BLOCK
# ==============================================================================

resource "aws_security_group" "ingress_rule" {
  name   = "aws-sg-tfm"

#   ingress {
#     from_port = 80
#     to_port = 80
#     cidr_blocks = ["0.0.0.0/0"]
#     protocol = "http"
#   }

dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port = ingress.value.from_port
    to_port = ingress.value.to_port
    cidr_blocks = ingress.value.cidr_blocks
    protocol = ingress.value.protocol
  }
}

}

# ==============================================================================
# EXAMPLE 3: SPLAT EXPRESSION
# ==============================================================================

resource "aws_instance" "splat_instances" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
  instance_type = "t2.micro"

  tags = var.tags
}

locals {
  all_instance_id = aws_instance.splat_instances[*].id
}

output "instances_id" {
  value = local.all_instance_id
}
