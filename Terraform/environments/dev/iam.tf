# 1. IAM Role that EC2 can assume
resource "aws_iam_role" "ec2_s3_role" {
  name = "${var.project_name}-${var.environment}-ec2-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-s3-role"
  }
}


# 2. IAM Policy granting access to S3 bucket
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "${var.project_name}-${var.environment}-ec2-s3-policy"
  description = "Allow EC2 instance to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
      }
    ]
  })
}


# 3. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}


# 4.  Instance Profile for the container that holds the role for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_s3_role.name
}