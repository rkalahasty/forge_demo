├── app/
│   ├── src/
│   │   ├── main.jl          # Julia source code for the app
│   │   ├── Database.jl      # Module for interacting with RDS database
│   │   └── Utils.jl         # Utility functions (hostname, version handling, etc.)
│   ├── Dockerfile           # Dockerfile for containerizing the Julia app 
│   └── requirements.txt     # Optional if any Python/other dependencies 
├── ansible/
│   ├── playbook.yml         # Ansible playbook for configuring the EC2 instance and NGINX
│   ├── roles/
│   │   ├── app/
│   │   │   └── tasks/main.yml  # Tasks to deploy the app on EC2 instance
│   │   ├── nginx/
│   │   │   └── tasks/main.yml  # Tasks to configure NGINX load balancer
│   └── inventory             # Inventory file defining EC2 instances
├── terraform/
│   ├── main.tf               # Main Terraform configuration for infrastructure setup
│   ├── variables.tf          # Terraform variables
│   ├── outputs.tf            # Terraform outputs (EC2 public IP, RDS endpoint, etc.)
│   ├── provider.tf           # AWS provider configuration
│   ├── ecs.tf                # ECS resources (optional, if you choose to deploy via ECS)
│   ├── rds.tf                # RDS database setup
│   ├── ec2.tf                # EC2 instance setup
│   ├── lb.tf                 # Load balancer configuration
│   └── dns.tf                # DNS configuration (public DNS records)
├── .github/
│   └── workflows/
│       └── ci_cd.yml         # GitHub Actions workflow for CI/CD
└── README.txt                # Project documentation
