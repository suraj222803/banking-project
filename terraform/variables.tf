variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type        = list(string)
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "eks_role_arn" {
  type        = string
  description = "ARN of the IAM role for the EKS cluster"
}


variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}


variable "cluster_name" {
  type = string
}


variable "node_instance_type" {
  type        = string
  default     = "t3.medium"
}

variable "node_count" {
  type        = number
  default     = 2
}

variable "node_ami_id" {
  type        = string
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "banking-app"
}


variable "db_secret_name" {
  type = string
}

