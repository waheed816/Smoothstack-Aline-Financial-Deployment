terraform {

  backend "s3" {
    bucket = "s3-bucket-mm"
    dynamodb_table = "terraform_eks_state_lock_mm"
    key = "terraform_eks_state/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  required_version = ">= 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.49.0"

    }
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}







# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks-cluster-mm.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-mm.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks-cluster-mm.token

# }
