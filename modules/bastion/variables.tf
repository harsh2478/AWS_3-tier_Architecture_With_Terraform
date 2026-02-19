variable "tags" {
  description = "Common tag for all resources"
  type = map(string)
  default = {}
}

variable "environment" {
  description = "Environment Name (eg: dev, stage, prod)"
  type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type = string
  default = ""
}

variable "instance_type" {
  description = "EC2 Instane Type"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair"
  type = string
}

variable "subnet_id" {
  description = "Public Subnet ID for Bastion Host"
  type = string
}

variable "security_group_id" {
  description = "Security Group ID for bastion host"
  type = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for bastion"
  type = string
}
