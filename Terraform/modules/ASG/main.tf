module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 9.0"

  name = "${var.project_name}-${var.environment}-asg"

  # Subnets for instance placement
  vpc_zone_identifier = var.subnet_ids

  # Capacity management
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  # Load Balancer target group attachment & auto-healing
  health_check_type         = var.health_check_type
  wait_for_capacity_timeout = 0

  traffic_source_attachments = {
    for idx, arn in var.target_group_arns : "alb-${idx}" => {
      traffic_source_identifier = arn
      traffic_source_type       = "elbv2"
    }
  }

  # Launch Template Settings
  launch_template_name   = "${var.project_name}-${var.environment}-lt"
  update_default_version = true

  image_id        = var.image_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  user_data       = var.user_data != null ? base64encode(var.user_data) : null
  security_groups = var.security_group_ids

  # Attach pre-existing IAM Instance Profile
  create_iam_instance_profile = false
  iam_instance_profile_name   = var.iam_instance_profile_name

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-asg-instance"
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}
