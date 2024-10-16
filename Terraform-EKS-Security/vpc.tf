resource "aws_vpc" "vpc-mm" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-mm"
  }
}

resource "aws_subnet" "public-subnet-a-mm" {
  vpc_id            = aws_vpc.vpc-mm.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a-mm"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cluster-mm" = "shared"
    # "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster-mm.name}" = "shared"

  }

  depends_on = [aws_vpc.vpc-mm]
}

resource "aws_subnet" "public-subnet-b-mm" {
  vpc_id            = aws_vpc.vpc-mm.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b-mm"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cluster-mm" = "shared"
    # "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster-mm.name}" = "shared"

  }



  depends_on = [aws_vpc.vpc-mm]
}

resource "aws_subnet" "public-subnet-c-mm" {
  vpc_id            = aws_vpc.vpc-mm.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-c-mm"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cluster-mm" = "shared"

  }

  depends_on = [aws_vpc.vpc-mm]
}

resource "aws_internet_gateway" "public-igw-mm" {
  vpc_id = aws_vpc.vpc-mm.id

  tags = {
    Name = "public-igw-mm"
    # "kubernetes.io/cluster/eks-cluster-mm" = "shared"
  }

  depends_on = [aws_vpc.vpc-mm]
}

resource "aws_route_table" "public-route-table-mm" {
  vpc_id = aws_vpc.vpc-mm.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-igw-mm.id
  }

  tags = {
    Name = "public-route-table-mm"
    # "kubernetes.io/cluster/eks-cluster-mm" = "shared"
  }

  depends_on = [aws_internet_gateway.public-igw-mm]
}

resource "aws_route_table_association" "public-rta-a" {
  subnet_id      = aws_subnet.public-subnet-a-mm.id
  route_table_id = aws_route_table.public-route-table-mm.id

  depends_on = [
    aws_subnet.public-subnet-a-mm,
    aws_route_table.public-route-table-mm
  ]
}

resource "aws_route_table_association" "public-rta-b" {
  subnet_id      = aws_subnet.public-subnet-b-mm.id
  route_table_id = aws_route_table.public-route-table-mm.id

  depends_on = [
    aws_subnet.public-subnet-b-mm,
    aws_route_table.public-route-table-mm
  ]
}

resource "aws_route_table_association" "public-rta-c" {
  subnet_id      = aws_subnet.public-subnet-c-mm.id
  route_table_id = aws_route_table.public-route-table-mm.id

  depends_on = [
    aws_subnet.public-subnet-c-mm,
    aws_route_table.public-route-table-mm
  ]
}

# Get all the subnet ids
# data "aws_subnets" "subnets-mm" {
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.vpc-mm.id]
#   }
# }
