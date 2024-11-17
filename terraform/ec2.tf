# Security group for the EC2 instances (both app and NGINX)
resource "aws_security_group" "app_sg" {
  name        = "julia-app-sg"
  description = "Security group for the Julia app and NGINX"
  vpc_id      = module.vpc.vpc_id

  # Ingress rule: Allow HTTP traffic on port 80 for NGINX
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule: Allow HTTPS traffic on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule: Allow traffic on port 8080 for the app
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "julia-app-sg"
  }
}

# EC2 instance for the Julia app
resource "aws_instance" "app" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "Julia App Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker pull ${var.docker_image}
              sudo docker run -d -p 8080:8080 \
                --env DB_HOST=${aws_db_instance.julia_app_rds.address} \
                --env DB_NAME=${var.db_name} \
                --env DB_USER=${var.db_user} \
                --env DB_PASSWORD=${var.db_password} \
                ${var.docker_image}
              EOF
}

# EC2 instance for NGINX load balancer
resource "aws_instance" "nginx" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = module.vpc.public_subnets[1]
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    Name = "NGINX Load Balancer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx

              # Configure NGINX as reverse proxy
              sudo bash -c 'cat > /etc/nginx/sites-available/default' << EOL
              server {
                  listen 80;
                  server_name _;

                  location / {
                      proxy_pass http://localhost:8080;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOL

              sudo systemctl restart nginx
              EOF
}
