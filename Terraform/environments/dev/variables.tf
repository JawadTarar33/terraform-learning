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