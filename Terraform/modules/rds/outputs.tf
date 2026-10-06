output "rds_endpoint" {
  description = "RDS instance connection endpoint (address:port)"
  value       = module.rds.db_instance_endpoint
}

output "rds_address" {
  description = "RDS hostname / address"
  value       = module.rds.db_instance_address
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "db_port" {
  description = "Database port"
  value       = module.rds.db_instance_port
}