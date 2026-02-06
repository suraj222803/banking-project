variable "aws_region" {
  type    = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "ssh_key_name" {
  type = string
  default = "project-key"  
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "ecr_repo_name" {
  type = string
}
