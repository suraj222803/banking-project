resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  tags = {
    Name = var.cluster_name
  }
}


# EKS Node Group

resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.private_subnets

  instance_types = ["t3.micro"]
  ami_type       = "AL2_x86_64"

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  capacity_type = "ON_DEMAND"

  
  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}
