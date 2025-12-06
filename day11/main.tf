# ==============================================================================
# FUNCTIONS
# ==============================================================================


locals {
  formatted_project_name = lower(replace(var.project_name," ","-"))
  new_tag = merge(var.default-tags, var.environment_tags)
  formatted_bucket_name = replace(replace(
    substr(lower(var.bucket_name),0,63),
    " ",""
  ),"!",""
  )


  port_list = split(",", var.allowed_ports)

  sg_rules = [
    for port in local.port_list : 
    {
      name = "port-${port}"
      port = port
      description = "Allow traffic on port ${port}"
    }
  ]



  instance_sizes = lookup(var.instance_sizes, var.environment, "t2.micro")
}

resource "aws_s3_bucket" "example-tf-bucket" {
  bucket = local.formatted_bucket_name

  tags = local.new_tag
}
