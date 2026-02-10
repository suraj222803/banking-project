resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.private_subnets
  }

  tags = {
    Name = var.cluster_name
  }
}


# EKS Node Group

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_instance_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }


  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}
