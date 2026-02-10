variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "eks_role_arn" {
  type = string
}

variable "node_instance_role_arn" {
  type = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.micro"]
}

variable "ami_id" {
  type    = list(string)
  default = ["ami-0b6c6ebed2801a5cb"]
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "ssh_key_name" {
  type = string
}

variable "source_security_group_ids" {
  type = list(string)
}
