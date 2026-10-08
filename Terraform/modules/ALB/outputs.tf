output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.arn
}

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = module.alb.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"
  value       = module.alb.zone_id
}

output "security_group_id" {
  description = "ID of the security group created for the ALB"
  value       = module.alb.security_group_id
}

output "target_groups" {
  description = "Map of all target groups created"
  value       = module.alb.target_groups
}

output "target_group_arn" {
  description = "ARN of the primary 'app' target group (ready for ASG attachment)"
  value       = module.alb.target_groups["app"].arn
}
