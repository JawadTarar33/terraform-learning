variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devops-learning"
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "VPC ID where the ALB and Target Group will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port the target group and EC2 backend applications listen on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all ALB resources"
  type        = map(string)
  default     = {}
}
