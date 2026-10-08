# 1. VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = "10.0.0.0/16"
  azs      = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true
}

# Generate SSH Key Pair for EC2 access
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dev_key" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.dev_key.public_key_openssh
}

resource "local_file" "dev_key_pem" {
  content         = tls_private_key.dev_key.private_key_pem
  filename        = "${path.module}/dev-key.pem"
  file_permission = "0400"
}

# 2. EC2 Module (connected to VPC public subnet & RDS private subnet)
module "ec2" {
  source = "../../modules/ec2"

  project_name           = var.project_name
  environment            = var.environment
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip    = true
  key_name               = aws_key_pair.dev_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
}

# 3. RDS Module (Ready for future expansion)
module "rds" {
  source                 = "../../modules/rds"
  project_name           = var.project_name
  environment            = var.environment
  db_subnet_ids          = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  db_username = "devops"
  db_password = var.db_password
}

# 4. S3 Module
module "s3" {
  source = "../../modules/s3"

  bucket_name                   = var.bucket_name
  tags                          = var.tags
  enable_versioning             = var.enable_versioning
  enable_server_side_encryption = var.enable_server_side_encryption
  lifecycle_rules               = var.lifecycle_rules
  bucket_public_access_block    = var.bucket_public_access_block
}

# 5. ALB Module (in public subnets)
module "alb" {
  source = "../../modules/ALB"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets
  tags         = var.tags
}

# 6. ASG Module (connected to ALB target group)
module "asg" {
  source = "../../modules/ASG"

  project_name              = var.project_name
  environment               = var.environment
  subnet_ids                = module.vpc.public_subnets
  image_id                  = module.ec2.ami_id
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.dev_key.key_name
  iam_instance_profile_name = aws_iam_instance_profile.ec2_profile.name
  security_group_ids        = [aws_security_group.ec2_sg.id]
  target_group_arns         = [module.alb.target_group_arn]

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              mkdir -p /var/www/html
              echo "<h1>Deployed via ASG + ALB! Host: $(hostname)</h1>" > /var/www/html/index.html
              systemctl enable nginx
              systemctl restart nginx
              EOF

  tags = var.tags
}

#SECURITY GROUPS
# 1. EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Web Traffic from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}

# 2. RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}