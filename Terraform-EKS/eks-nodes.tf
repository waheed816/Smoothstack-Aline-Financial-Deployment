resource "aws_eks_node_group" "node_group-mm" {
  cluster_name    = aws_eks_cluster.eks-cluster-mm.name
  node_group_name = "node-group-mm"
  node_role_arn   = aws_iam_role.eks-node-role-mm.arn
  subnet_ids = [aws_subnet.public-subnet-a-mm.id,
                aws_subnet.public-subnet-b-mm.id,
                aws_subnet.public-subnet-c-mm.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  ami_type        = "AL2_ARM_64"
  instance_types   = ["t4g.small"]
  disk_size       = 20

  remote_access {
    ec2_ssh_key = "ec2-ssh-key-mm"
    source_security_group_ids = [aws_security_group.eks-worker-nodes-sg-mm.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "node-group-mm"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy_ec2,
    aws_iam_role_policy_attachment.node_policy_cni,
    aws_iam_role_policy_attachment.node_policy_worker_node,
    aws_iam_role_policy_attachment.node_policy_rds,
    aws_iam_role_policy_attachment.node_policy_ssm,
  ]

}
