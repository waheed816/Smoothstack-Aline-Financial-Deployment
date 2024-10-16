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

resource "aws_security_group" "ansible_security_mm" {
  name        = "ansible-security-mm"
  description = "Security group for Ansible SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-security-mm"
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

resource "aws_instance" "ubuntu" {
  ami           = "ami-0c14ff330901e49ff"
  instance_type = "t4g.micro"
  key_name      = "ec2-ssh-key-mm"
  vpc_security_group_ids = [
    aws_security_group.ansible_security_mm.id
  ]
  subnet_id = data.aws_subnet.default.id
  tags = {
    Name = "ubuntu-instance-mm"
  }
}

resource "aws_instance" "rhel" {
  ami           = "ami-07472131ec292b5da"
  instance_type = "t4g.micro"
  key_name      = "ec2-ssh-key-mm"
  vpc_security_group_ids = [
    aws_security_group.ansible_security_mm.id
  ]
  subnet_id = data.aws_subnet.default.id
  tags = {
    Name = "rhel-instance-mm"
  }
}

resource "aws_instance" "amazon_linux" {
  ami           = "ami-0582e4fe9b72a5fe1"
  instance_type = "t4g.micro"
  key_name      = "ec2-ssh-key-mm"
  vpc_security_group_ids = [
    aws_security_group.ansible_security_mm.id
  ]
  subnet_id = data.aws_subnet.default.id
  tags = {
    Name = "amazon-linux-instance-mm"
  }
}

output "ubuntu_instance_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "rhel_instance_ip" {
  value = aws_instance.rhel.public_ip
}

output "amazon_linux_instance_ip" {
  value = aws_instance.amazon_linux.public_ip
}
