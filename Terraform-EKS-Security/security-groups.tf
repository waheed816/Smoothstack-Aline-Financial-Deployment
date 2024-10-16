#EKS control plane security group
resource "aws_security_group" "eks-control-plane-sg-mm" {
  name        = "eks-control-plane-sg-mm"
  description = "Security group for EKS control plane"
  vpc_id      = aws_vpc.vpc-mm.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Worker nodes security group
resource "aws_security_group" "eks-worker-nodes-sg-mm" {
  name        = "eks-worker-nodes-sg-mm"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.vpc-mm.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.eks-control-plane-sg-mm.id]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # cidr_blocks = ["192.168.1.178/32"]
    cidr_blocks = ["192.168.119.151/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#RDS security group
module "rds_sg_mm"{
# module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "~> 5.0"
  version = "5.1.2"

  name        = "rds-sg-mm"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.vpc-mm.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = aws_vpc.vpc-mm.cidr_block
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
# resource "aws_security_group" "rds-sg-mm" {
#   name        = "rds-sg-mm"
#   description = "Security group for RDS instance"
#   vpc_id      = aws_vpc.vpc-mm.id

# #   ingress {
# #     from_port   = 3306
# #     to_port     = 3306
# #     protocol    = "tcp"
# #     security_groups = [aws_security_group.eks-worker-nodes-sg-mm.id]  # Allowing access from worker nodes
# #   }

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     # cidr_blocks = ["192.168.1.178/32"]
#     cidr_blocks = ["192.168.119.151/32"]
#   }

#   ingress {
#       from_port   = 3306
#       to_port     = 3306
#       protocol    = "tcp"
#       description = "MySQL access from within VPC"
#       cidr_blocks = aws_vpc.vpc-mm.cidr_block
# }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
