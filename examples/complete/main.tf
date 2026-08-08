terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name                = "${var.name}-vpc"
  cidr_block          = "10.0.0.0/16"
  azs                 = var.azs
  public_subnet_cidrs = ["10.0.0.0/24"]
  enable_nat_gateway  = false

  tags = var.tags
}

module "web_sg" {
  source = "../../modules/security-group"

  name        = "${var.name}-web"
  description = "Allow HTTP and SSH from the admin CIDR"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.admin_cidr]
    }
  ]

  tags = var.tags
}

module "app_server" {
  source = "../../modules/ec2-instance"

  name                = "${var.name}-app"
  instance_type       = "t3.micro"
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [module.web_sg.security_group_id]
  associate_public_ip = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = var.tags
}

module "assets_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name = "${var.name}-assets-${random_id.suffix.hex}"

  tags = var.tags
}

resource "random_id" "suffix" {
  byte_length = 4
}
