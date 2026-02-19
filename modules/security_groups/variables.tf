variable "environment" {
    description = "Environment Name (eg: dev, stage, prod)" 
    type = string
    default = "Dev" 
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "vpc_id" {
  description = "ID of VPC"
  type = string
}

variable "tags" {
  description = "Tags for all resources"
  type = map(string)
  default = {}
}

variable "allowed_ssh_cidrs" {
  description = "Allowed cidrs for SSH into Bastion"
  type = list(string)
  default = [ "0.0.0.0/0" ]
}