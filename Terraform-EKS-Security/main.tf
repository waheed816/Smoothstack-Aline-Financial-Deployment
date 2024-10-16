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

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks-cluster-mm.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster-mm.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster-mm.name]
    }

    config_path    = ""
    config_context = ""
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name]
  }
}





# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks-cluster-mm.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-mm.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks-cluster-mm.token

# }
