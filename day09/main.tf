# ==============================
#Create before destroy rule
# ==============================

resource "aws_instance" "ec2-example" {
  # ami = "ami-0ff8a91507f77f867"
  ami = "ami-0c02fb55956c7d316"
  instance_type = var.allowed_vm_type[0]
  region = var.region

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# # ==============================
# # Prevent Destroy Rule
# # ==============================

resource "aws_s3_bucket" "critical_data" {
  bucket = "my-critical-data-${var.environment}-${var.region}"

  tags = var.tags

  lifecycle {
    prevent_destroy = false
  }
}

# # ==============================
# # Example 3: ignore_changes
# # ==============================

# Launch Template for Auto Scaling Group

resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-launch"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = var.allowed_vm_type[0]

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }
}

#Auto Scaling Group

resource "aws_autoscaling_group" "app_servers" {
  name = "demo-app-asg-tf"
  max_size = 5
  min_size = 1
  desired_capacity = 2
  health_check_type  = "EC2"
  availability_zones = var.availability_zones

launch_template {
  id = aws_launch_template.app_server.id
  version = "$Latest"
}


lifecycle {
  ignore_changes = [desired_capacity]
}
}



# ==============================
# Example 6: replace_triggered_by
# ==============================

# Security Group

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "10.0.0.0/24"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "10.0.0.0/24"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0", "10.0.0.0/24"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}

# EC2 Instance that gets replaced when security group changes

resource "aws_instance" "app_with_sg" {
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = var.allowed_vm_type[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = var.tags

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}


# ==============================
# Example 4: precondition
# Use Case: Ensure we're deploying in an allowed region
# ==============================

resource "aws_s3_bucket" "regional_validation" {
  bucket = "validated-region-bucket-${var.environment}-${data.aws_region.current.name}"

  tags = var.tags

  # Lifecycle Rule: Validate region before creating resource
  # This prevents resource creation in unauthorized regions
  lifecycle {
    precondition {
      condition     = contains(var.region, data.aws_region.current.name)
      error_message = "ERROR: This resource can only be created in allowed regions: ${join(", ", var.allowed_region)}. Current region: ${data.aws_region.current.name}"
    }
  }
}


# ==============================
# Example 5: postcondition
# Use Case: Ensure S3 bucket has required tags after creation
# ==============================

resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket-${var.environment}-${tolist(var.allowed_region)[0]}"

  tags = var.tags

  # Lifecycle Rule: Validate bucket has required tags after creation
  # This ensures compliance with organizational tagging policies
  lifecycle {
    postcondition {
      condition     = contains(keys(var.tags), "Compliance")
      error_message = "ERROR: Bucket must have a 'Compliance' tag for audit purposes!"
    }
  }
}
