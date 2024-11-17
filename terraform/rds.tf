# Subnet group for the RDS instance, using private subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "julia-app-rds-subnet-group"
  description = "Subnet group for the Julia app RDS instance"
  subnet_ids  = module.vpc.private_subnets

  tags = {
    Name = "julia-app-rds-subnet-group"
  }
}

# Security group for the RDS instance to allow access from the EC2 app instances
resource "aws_security_group" "rds_sg" {
  name        = "julia-app-rds-sg"
  description = "Security group for the Julia app RDS instance"
  vpc_id      = module.vpc.vpc_id

  # Ingress rule: Allow PostgreSQL access from app servers (port 5432)
  ingress {
    description     = "Allow PostgreSQL access from app servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Egress rule: Allow all outbound traffic (standard for RDS)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "julia-app-rds-sg"
  }
}

# RDS PostgreSQL instance
resource "aws_db_instance" "julia_app_rds" {
  identifier              = "julia-app-rds"
  allocated_storage       = 20                                        # Storage in GB (adjust as needed)
  engine                  = "postgres"                                # Use PostgreSQL
  engine_version          = "12.20"                                    # PostgreSQL version (ensure it's available in your region)
  instance_class          = var.db_instance_class                     # Instance type, e.g., db.t3.micro
  db_name                 = var.db_name                               # Initial database name
  username                = var.db_user                               # Master username
  password                = var.db_password                           # Master password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name # Associate with the subnet group
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]            # Attach security group
  publicly_accessible     = false                                     # Keep the database private
  multi_az                = false                                     # Enable Multi-AZ for production (optional)
  storage_type            = "gp2"                                     # General-purpose SSD storage
  backup_retention_period = 7                                         # Retain backups for 7 days
  skip_final_snapshot     = true                                      # Skip final snapshot when deleting (set to false for production)
  apply_immediately       = true                                      # Apply changes immediately (use cautiously in production)

  # Enable automatic backups
  backup_window      = "03:00-04:00"         # Daily backup window
  maintenance_window = "Mon:04:00-Mon:05:00" # Weekly maintenance window

  tags = {
    Name        = "julia-app-rds"
    Environment = var.environment
  }
}
