module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name    = "${var.project_name}-${var.environment}-alb"
  vpc_id  = var.vpc_id
  subnets = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  # Security Group managed by the ALB module
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic from internet"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # HTTP Port 80 Listener forwarding to the Target Group
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "app"
      }
    }
  }

  # Target Group for EC2 instances / ASG
  target_groups = {
    app = {
      name_prefix       = "app-"
      protocol          = "HTTP"
      port              = var.target_port
      target_type       = "instance"
      create_attachment = false # ASG will dynamically attach instances

      health_check = {
        enabled             = true
        path                = var.health_check_path
        port                = "traffic-port"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
        matcher             = "200-399"
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-alb"
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}
