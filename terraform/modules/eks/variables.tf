variable "cluster_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "eks_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
}
