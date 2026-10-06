output "iam_user_name" {
  description = "The name of the IAM user created"
  value       = aws_iam_user.terraform_user.name
}

output "iam_user_arn" {
  description = "The ARN of the IAM user"
  value       = aws_iam_user.terraform_user.arn
}

output "access_key_id" {
  description = "AWS Access Key ID for CLI configuration"
  value       = aws_iam_access_key.terraform_key.id
}

output "secret_access_key" {
  description = "AWS Secret Access Key for CLI configuration"
  value       = aws_iam_access_key.terraform_key.secret
  sensitive   = true
}
