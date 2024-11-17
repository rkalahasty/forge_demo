# AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "eu-central-1"
}

# VPC configuration
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "my-app-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# EC2 configuration
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances"
  default     = "ami-07dfba995513840b5"  # Example for Ubuntu 20.04 in eu-central-1
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t3.micro"
}

variable "key_name" {
  description = "The key pair name to use for SSH access to EC2 instances"
  type        = string
}

# Docker image for the Julia app
variable "docker_image" {
  description = "The Docker image to run the Julia app"
  default     = "julia-app:latest"
}

# RDS configuration
variable "db_name" {
  description = "The name of the initial PostgreSQL database"
  type        = string
  default     = "myappdb"
}

variable "db_user" {
  description = "The master username for PostgreSQL"
  type        = string
  default     = "dbuser"
}

variable "db_password" {
  description = "The master password for PostgreSQL"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

# DNS configuration
variable "domain_name" {
  description = "The domain name hosted in Route 53"
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the application (e.g., app for app.example.com)"
  type        = string
  default     = "app"
}

# Environment tag
variable "environment" {
  description = "The environment (e.g., dev, prod) for resource tagging"
  default     = "dev"
}
