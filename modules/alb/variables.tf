variable "environment" {
  description = "Environment Name"
  type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "name_prefix" {
  description = "Prefix for ALB name (Eg: Public-, Private-)"
  type = string
  default = ""
}

variable "internal" {
  description = "Whether ALB is internal"
  type = bool
  default = false
}

variable "security_group_id" {
  description = "Security Group for ALB"
  type = string
}

variable "subnet_ids" {
  description = "List of public subnets for ALB"
  type = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type = bool
  default = false
}

variable "tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {}
}

variable "target_group_port" {
  description = "Port for the targte group"
  type = number
  default = 3000
}

variable "vpc_id" {
  description = "ID of the VPC where ALB will launch"
  type = string
}



