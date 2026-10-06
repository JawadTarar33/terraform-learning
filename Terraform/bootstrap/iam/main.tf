# IAM user for Terraform automation
resource "aws_iam_user" "terraform_user" {
  name = var.iam_user_name

  tags = {
    Project   = "devops-learning"
    Purpose   = "Terraform Automation"
    ManagedBy = "Terraform-Bootstrap"
  }
}

resource "aws_iam_user_policy_attachment" "terraform_admin_attach" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Access Keys for user to configure AWS CLI / Terraform Cloud
resource "aws_iam_access_key" "terraform_key" {
  user = aws_iam_user.terraform_user.name
}
