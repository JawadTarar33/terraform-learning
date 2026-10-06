module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.2"

  identifier = "${var.project_name}-${var.environment}-db"

  engine         = var.db_engine
  engine_version = var.db_engine_version
  family         = "${var.db_engine}${var.db_engine_version}" # postgres16
  instance_class = var.db_instance_type

  allocated_storage = var.db_allocated_storage

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = false
  password_wo                 = var.db_password
  password_wo_version         = 1
  port                        = var.db_port

  # Manage DB subnet group automatically
  create_db_subnet_group = true
  subnet_ids             = var.db_subnet_ids

  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot = var.db_skip_final_snapshot
  deletion_protection = var.db_deletion_protection

  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
