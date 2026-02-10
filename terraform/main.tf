module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  vpc_name        = var.vpc_name
}

module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
}


module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id    = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids   # Pass private subnets to EKS

  eks_role_arn = module.iam.eks_cluster_role_arn
}




module "ecr" {
  source = "./modules/ecr"

  ecr_repo_name = var.ecr_repository_name
}
