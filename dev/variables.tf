variable "environment" {
  description = "Environment Name (eg: dev, stage, prod)"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "CIDR for Public Subnets"
  type        = list(string)
}

variable "frontend_subnets" {
  description = "CIDR for Frontend Subnets"
  type        = list(string)
}

variable "Backend_subnets" {
  description = "CIDR for Frontend Subnets"
  type        = list(string)
}

variable "database_subnets" {
  description = "CIDR for Database Subnets"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use Single Nat Gateway for all Private Subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "goalsDB"
}

variable "db_instance_class" {
  description = "Instance class of database instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Databse Allocated Storage"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "PostgresSql engine version"
  type        = string
  default     = "15.15"
}

variable "multi_az" {
  description = "Enable multi az deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup Retention Period in days"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type        = bool
}

variable "bastion_instance_type" {
  description = "Instance type for Bastion host"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "Key Name for SSH Login"
  type        = string
}

variable "frontend_instance_type" {
  description = "Instance type for frontend server"
  type        = string
  default     = "t2.micro"
}

variable "frontend_min_size" {
  description = "Frontend Minimum number of Instances"
  type        = number
  default     = 2
}

variable "frontend_max_size" {
  description = "Frontend Maximum number of Instances"
  type        = number
  default     = 7
}

variable "frontend_desired_capacity" {
  description = "Frontend desired number of instances"
  type        = number
  default     = 2
}

variable "frontend_docker_image" {
  description = "Full Docker Image (eg, username/image:tag)"
  type        = string
}

variable "backend_instance_type" {
  description = "Backend instance type"
  type        = string
  default     = "t3.micro"
}

variable "backend_min_size" {
  description = "Backend ASG minimum size"
  type        = number
  default     = 2
}

variable "backend_max_size" {
  description = "Backend ASG maximum size"
  type        = number
  default     = 6
}

variable "backend_desired_capacity" {
  description = "Backend ASG desired capacity"
  type        = number
  default     = 2
}

variable "backend_docker_image" {
  description = "Backend Docker image (e.g., username/backend:latest)"
  type        = string
}

variable "region" {
  description = "Region Name"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "Allowed cidrs for SSH into Bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "dockerhub_username" {
  description = "DockerHub Username (Leave Empty if image is public)"
  type        = string
  default     = ""
}

variable "dockerhub_password" {
  description = "DockerHub Password (Leave Empty if image is public)"
  type        = string
  default     = ""
  sensitive   = true
}