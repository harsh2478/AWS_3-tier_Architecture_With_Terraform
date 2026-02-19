variable "environment" {
    description = "Environment Name (eg: dev, stage, prod)" 
    type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "subnet_ids" {
  description = "Subnet Ids for Database subnet group"
  type = list(string)
}

variable "tags" {
  description = "Common tag for all"
  type = map(string)
  default = {}
}

variable "engine_version" {
  description = "PostgresSql engine version"
  type = string
  default = "15.15"
}

variable "instance_class" {
  description = "Instance class for RDS"
  type = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated Storage in GB"
  type = number
  default = 20
}

variable "db_username" {
  description = "Database master username"
  type = string
  default = "postgres"
}

variable "db_password" {
  description = "Database master password"
  type = string
  sensitive = true
}

variable "db_name" {
  description = "Database name"
  type = string
  default = "goalsDB"
}

variable "security_group_id" {
  description = "Security Group for Database"
  type = string
}

variable "multi_az" {
  description = "Enable multi az deployment"
  type = bool
}

variable "availability_zone" {
  description = "Availability Zones for single az deployment"
  type = string
  default = null
}

variable "backup_retention_period" {
  description = "Backup Retention Period in days"
  type = number
  default = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type = bool
}

variable "monitoring_interval" {
  description = "Monitoring Interval in seconds (0, 1, 2, 5, 10, 30, 60)"
  type = number
  default = 0
}

variable "deletion_protection" {
    description = "Enable delete protection"
    type = bool
    default = false
}