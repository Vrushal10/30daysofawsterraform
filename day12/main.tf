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


  all_locations = concat(var.user_locations, var.default_locations)
  unique_locations = toset(local.all_locations)


  postive_cost = [for cost in var.monthly_costs : abs(cost)]
  max_cost = max(local.postive_cost...)
  min_cost = min(local.postive_cost...)
  total_cost = sum(local.postive_cost)
  average_cost = local.total_cost / length(local.postive_cost)



  current_time = timestamp()
  format1 = formatdate("yyyyMMdd", local.current_time)
  format2 = formatdate("YYYY-MM-DD", local.current_time)
  backup_timestamp_name = "backup-${local.format2}"
}


# ==============================================================================
# Functions: timestamp(), formatdate()
# ==============================================================================

locals {
  # Generate current timestamp
  current_timestamp = timestamp()
  
  # Format for resource names: YYYYMMDD
  resource_date_suffix = formatdate("YYYYMMDD", local.current_timestamp)
  
  # Format for tags: DD-MM-YYYY
  tag_date_format = formatdate("DD-MM-YYYY", local.current_timestamp)
  
  # Create timestamped resource name
  timestamped_name = "backup-${local.resource_date_suffix}"
}

resource "aws_s3_bucket" "timestamped_bucket" {
  bucket = "my-backup-${local.resource_date_suffix}"
  
  tags = {
    Name       = local.timestamped_name
    CreatedOn  = local.tag_date_format
    Timestamp  = local.current_timestamp
  }
}

resource "aws_s3_bucket" "example-tf-bucket" {
  bucket = local.formatted_bucket_name

  tags = local.new_tag
}


# ==============================================================================
# Functions: File Functions
# ==============================================================================

locals {
      ## Checks if file exists or not
  config_file_exists = fileexists("./config.json")

     ## Print the data of the config file if it is present, or else will print the default
  config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {
    database = {
      host     = "localhost"
      port     = 5432
      username = "default"
    }
  }
}

# Store sensitive configuration in AWS Secrets Manager

resource "aws_secretsmanager_secret" "app_config" {
  name        = "app-configuration-${formatdate("YYYYMMDD-hhmm", timestamp())}"
  description = "Application configuration from file"
  
  tags = {
    Name        = "app-config"
    Sensitive   = "true"
    ConfigFile  = "./config.json"
  }
}

resource "aws_secretsmanager_secret_version" "app_config" {
  secret_id     = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode(local.config_data)
}