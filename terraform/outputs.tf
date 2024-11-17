# Cleaned-up outputs.tf
output "app_public_ip" {
  description = "The public IP of the Julia app EC2 instance"
  value       = aws_instance.app.public_ip
}

output "nginx_public_ip" {
  description = "The public IP of the NGINX load balancer EC2 instance"
  value       = aws_instance.nginx.public_ip
}

output "rds_endpoint" {
  description = "The RDS PostgreSQL endpoint"
  value       = aws_db_instance.julia_app_rds.endpoint
}

output "rds_db_name" {
  description = "The RDS PostgreSQL database name"
  value       = aws_db_instance.julia_app_rds.db_name
}

output "nginx_lb_dns" {
  description = "The DNS name of the NGINX load balancer"
  value       = aws_lb.nginx_lb.dns_name
}

output "app_dns_name" {
  description = "The full DNS name for the application"
  value       = "${var.subdomain}.${var.domain_name}"
}

