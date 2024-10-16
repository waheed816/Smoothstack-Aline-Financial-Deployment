terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50.0"
    }
  }
  required_version = ">= 1.3.2"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "semaphore_security_mm" {
  name        = "semaphore-security-mm"
  description = "Security group for Semaphore SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "semaphore-security-mm"
  }
}


data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

resource "aws_instance" "semaphore-instance-mm" {
  ami           = "ami-0c14ff330901e49ff"
  instance_type = "t4g.micro"
  key_name      = "ec2-ssh-key-mm"
  vpc_security_group_ids = [
    aws_security_group.semaphore_security_mm.id
  ]
  subnet_id = data.aws_subnet.default.id
  tags = {
    Name = "semaphore-instance-mm"
  }
}
