module "vpc" {
  source        = "./modules/vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  vpc_name      = "banking-vpc"
}


module "iam" {
  source = "./modules/iam"
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  vpc_id                   = module.vpc.vpc_id
  public_subnets            = module.vpc.public_subnet_ids
  private_subnets           = module.vpc.private_subnet_ids
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  eks_role_arn              = module.iam.eks_cluster_role_arn
  node_instance_role_arn    = module.iam.eks_node_role_arn
  node_instance_types       = var.node_instance_types
  ami_id                    = var.ami_id
  desired_size              = var.desired_size
  min_size                  = var.min_size
  max_size                  = var.max_size
  ssh_key_name              = var.ssh_key_name
  source_security_group_ids = [module.vpc.default_security_group_id]
}


module "ecr" {
  source = "./modules/ecr"
  ecr_repo_name = var.ecr_repo_name
}
