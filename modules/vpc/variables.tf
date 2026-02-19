variable "vpc_cidr_block" {
  description = "CIDR block for vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags for all resources"
  type = map(string)
  default = {}
}

variable "environment" {
    description = "Environment Name (eg: dev, stage, prod)" 
    type = string
    default = "Dev" 
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "enable_nat_gateway" {
  description = "Enable Nat Gateway for private subnets"
  type = bool
  default = true
}

variable "single_nat_gateway" {
  description = "Use Single Nat Gateway for all Private Subnets"
  type = bool
  default = true
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type = list(string)
}

variable "public_subnets" {
    description = "CIDR for Public Subnets"
    type = list(string)  
}

variable "frontend_subnets" {
  description = "CIDR for Frontend Subnets"
  type = list(string)
}

variable "Backend_subnets" {
  description = "CIDR for Frontend Subnets"
  type = list(string)
}

variable "database_subnets" {
  description = "CIDR for Database Subnets"
  type = list(string)
}