output "vpc_id" {
  description = "Created VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "ec2_instance_id" {
  description = "Deployed EC2 Instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2.public_dns
}

output "rds_endpoint" {
  description = "Connection endpoint of the RDS PostgreSQL instance"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  description = "Hostname of the RDS PostgreSQL instance"
  value       = module.rds.rds_address
}

