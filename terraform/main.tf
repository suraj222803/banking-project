module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  private_subnets = module.vpc.private_subnets
  # Do NOT pass eks_role_arn
}




module "ecr" {
  source        = "./modules/ecr"
  repo_name     = var.ecr_repo_name
}

module "secrets" {
  source       = "./modules/secrets"
  secret_name  = var.db_secret_name
}

