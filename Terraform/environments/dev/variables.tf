variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-learning"
}

variable "environment" {
  description = "Environment identifier"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

# --- S3 Variables ---
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "lifecycle_rules" {
  type    = any
  default = []
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "enable_server_side_encryption" {
  type    = bool
  default = true
}

variable "bucket_public_access_block" {
  type    = bool
  default = false
}

# --- Optional ASG Sizing Overrides ---
variable "asg_min_size" {
  description = "Minimum instances for ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum instances for ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired instances for ASG"
  type        = number
  default     = 2
}

# --- Tags ---
variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project     = "devops-learning"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
