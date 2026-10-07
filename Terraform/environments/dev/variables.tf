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
  default     = "t2.small"
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "lifecycle_rules" {
  type = list(object({
    enabled = bool
    id      = string
    prefix  = string
    tags    = map(string)
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_transitions = list(object({
      noncurrent_days = number
      storage_class   = string
    }))
    noncurrent_version_expiration = object({
      noncurrent_days = number
    })
    expiration = object({
      days = number
    })
    status = string
  }))
  default = []
}

variable "enable_versioning" {
  type        = bool
  description = "Enable versioning for the S3 bucket"
  default     = true
}

variable "enable_server_side_encryption" {
  type        = bool
  description = "Enable server-side encryption for the S3 bucket"
  default     = true
}

variable "bucket_public_access_block" {
  type        = bool
  description = "Enable public access block for the S3 bucket"
  default     = false
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project     = "devops-learning"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}