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

variable "subnet_ids" {
  description = "List of subnet IDs where ASG instances will be launched (private or public subnets)"
  type        = list(string)
}

variable "image_id" {
  description = "AMI ID to use for the Launch Template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to attach to the instances"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs for the instances"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Plain text user data script to run on instance boot (will be base64-encoded automatically)"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "List of target group ARNs from the ALB to register ASG instances into"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "Health check type for ASG ('EC2' or 'ELB')"
  type        = string
  default     = "ELB"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
