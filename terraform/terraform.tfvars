aws_region     = "us-east-1"
project_name  = "banking-app"

vpc_cidr = "10.0.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b"]

public_subnets = [
  "10.0.1.0/24",  # us-east-1a
  "10.0.2.0/24"   # us-east-1b
]

private_subnets = [
  "10.0.3.0/24",  # us-east-1a
  "10.0.4.0/24"   # us-east-1b
]

eks_role_arn = "arn:aws:iam::934424429123:role/my-existing-eks-role"

node_instance_type = "m7i-flex.large"
node_count         = 2
key_name           = "project-key"
node_ami_id        = "ami-0b6c6ebed2801a5cb"

cluster_name   = "banking-cluster"
ecr_repo_name  = "banking-app"
db_secret_name = "banking-db-secret"

