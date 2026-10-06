variable "aws_region" {
  description = "AWS region for provisioning"
  type        = string
  default     = "ap-northeast-2"
}

variable "iam_user_name" {
  description = "IAM user for Terraform automation"
  type        = string
  default     = "terraform-devops-admin"
}
