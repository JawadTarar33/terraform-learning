variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devops-learning"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}
