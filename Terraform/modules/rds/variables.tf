variable "project_name" {
    description = "Project name"
    type        = string
}

variable "environment" {
    description = "Environment name"
    type        = string
}

variable "db_subnet_ids" {
    description = "List of database subnet IDs"
    type        = list(string)
}

variable "vpc_security_group_ids" {
    description = "List of VPC security group IDs"
    type        = list(string)
}

variable "db_instance_type" {
    description = "RDS instance type"
    type        = string
    default     = "db.t3.small"
}

variable "db_engine" {
    description = "RDS engine"
    type        = string
    default     = "postgres"
}

variable "db_engine_version" {
    description = "RDS engine version"
    type        = string
    default     = "16"
}

variable "db_username" {
    description = "RDS username"
    type        = string
    default     = "postgres"
}

variable "db_password" {
    description = "RDS password"
    type        = string
}

variable "db_allocated_storage" {
    description = "RDS allocated storage"
    type        = number
    default     = 20
}

variable "db_skip_final_snapshot" {
    description = "RDS skip final snapshot"
    type        = bool
    default     = true
}

variable "db_deletion_protection" {
    description = "RDS deletion protection"
    type        = bool
    default     = false
}

variable "tags" {
    description = "Tags to apply to the RDS instance"
    type        = map(string)
    default     = { Project="devops-learning", Enviroment="dev"}
}

variable "db_name" {
    description = "Name of the database"
    type        = string
    default     = "devopsdb"
}

variable "db_port" {
    description = "Port number for the database"
    type        = number
    default     = 5432
}

variable "db_backup_retention_period" {
    description = "Backup retention period for the RDS instance"
    type        = number
    default     = 7
}

variable "db_backup_window" {
    description = "Backup window for the RDS instance"
    type        = string
    default     = "07:00-09:00"
}

