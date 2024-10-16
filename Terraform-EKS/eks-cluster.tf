resource "aws_eks_cluster" "eks-cluster-mm" {
  name     = "eks-cluster-mm"
  role_arn = aws_iam_role.eks-cluster-role-mm.arn

  vpc_config {
    # subnet_ids = [for subnet in data.aws_subnet.default_subnet : subnet.id]
    subnet_ids = [aws_subnet.public-subnet-a-mm.id,
                  aws_subnet.public-subnet-b-mm.id,
                  aws_subnet.public-subnet-c-mm.id]
    security_group_ids = [aws_security_group.eks-control-plane-sg-mm.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_VPC_resource_controller_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]


}

# data "aws_eks_cluster" "cluster" {
#   name = aws_eks_cluster.eks-cluster-mm.name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = aws_eks_cluster.eks-cluster-mm.name
# }
