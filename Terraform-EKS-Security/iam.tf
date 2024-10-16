#IAM Role for EKS Cluster
resource "aws_iam_role" "eks-cluster-role-mm" {
  name = "aline-eks-cluster-role-mm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Effect = "Allow",
    }]
  })
}

# Attach required policies to the IAM role to mange resources for the EKS cluster

# Grants the necessary permissions for EKS to manage the Kubernetes control plane.
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks-cluster-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Grants permissions needed for EKS to manage VPC resources on your behalf.
resource "aws_iam_role_policy_attachment" "eks_VPC_resource_controller_policy" {
  role       = aws_iam_role.eks-cluster-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# Grants EKS service necessary permissions to manage the EKS cluster and related resources.
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks-cluster-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}



# IAM Role for EKS Node Group
resource "aws_iam_role" "eks-node-role-mm" {
  name = "eks-node-role-mm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach required policies to the IAM role for EKS node group to grant the necessary permissions
# for the EC2 instances (worker nodes) in the EKS cluster to perform their tasks

# Grants EC2 instances read-only access to ECR to pull container images.
resource "aws_iam_role_policy_attachment" "node_policy_ec2" {
  role       = aws_iam_role.eks-node-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Grants permissions needed by the Amazon VPC CNI plugin for Kubernetes.
# Allows the worker nodes to manage network interfaces within the VPC.
resource "aws_iam_role_policy_attachment" "node_policy_cni" {
  role       = aws_iam_role.eks-node-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Grants permissions for the worker nodes to connect to the EKS cluster
resource "aws_iam_role_policy_attachment" "node_policy_worker_node" {
  role       = aws_iam_role.eks-node-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Grants access to Amazon RDS Data API, allowing the worker nodes to interact with RDS databases using the Data API
resource "aws_iam_role_policy_attachment" "node_policy_rds" {
  role       = aws_iam_role.eks-node-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

# grants the worker nodes access to AWS Systems Manager (SSM) for managing and maintaining the worker nodes
resource "aws_iam_role_policy_attachment" "node_policy_ssm" {
  role       = aws_iam_role.eks-node-role-mm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role" "lb_controller_role" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          //Specifies that the federated principal (OIDC provider) created earlier is allowed to assume the role
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        //assuming the role with a web identity token
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            //ensures that the subject (sub) of the token must match the specified value, which is the service account for the AWS Load Balancer Controller in the kube-system namespace
            "${replace(aws_eks_cluster.eks-cluster-mm.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            //ensures that the audience (aud) of the token is sts.amazonaws.com which allows you to request temporary security credentials for users to access AWS services and resources
            "${replace(aws_eks_cluster.eks-cluster-mm.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "local_file" "lb_controller_policy" {
  filename = "${path.module}/load-balancer-controller-iam-role-policy.json"
}

resource "aws_iam_policy" "lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy-mm"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.local_file.lb_controller_policy.content
}

resource "aws_iam_role_policy_attachment" "lb_controller_policy_attachment" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}
