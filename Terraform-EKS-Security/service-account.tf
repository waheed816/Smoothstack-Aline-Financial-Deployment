# resource "null_resource" "associate_oidc_provider" {
#   provisioner "local-exec" {
#     command = <<EOT
#       eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=eks-cluster-mm --approve
#     EOT
#   }

#   depends_on = [
#     aws_eks_cluster.eks-cluster-mm
#   ]
# }

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks-cluster-mm.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url = aws_eks_cluster.eks-cluster-mm.identity[0].oidc[0].issuer
}


# resource "null_resource" "apply_service_account" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks --region us-east-1 update-kubeconfig --name eks-cluster-mm
#       kubectl apply -f ${path.module}/service-account.yml
#     EOT
#   }

#   depends_on = [
#     aws_iam_openid_connect_provider.eks,
#     aws_iam_role.lb_controller_role,
#     aws_iam_role_policy_attachment.lb_controller_policy_attachment
#   ]

#   depends_on = [
#     aws_eks_cluster.eks-cluster-mm
#   ]

#   depends_on = [
#     null_resource.associate_oidc_provider  # Ensure this waits for the OIDC provider association
#   ]
# }
