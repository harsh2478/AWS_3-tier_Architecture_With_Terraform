variable "environment" {
    description = "Environment Name (eg: dev, stage, prod)" 
    type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "recovery_window_in_days" {
  description = "How long AWS keep the secret after deletion"
  type = number
  default = 0
}

variable "tags" {
  description = "Common tag for all resources"
  type = map(string)
  default = {}
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

variable "db_host" {
  description = "Database Endpoint Host"
  type = string
}

variable "db_port" {
  description = "Database Port"
  type = number
  default = 5432
}

variable "db_name" {
  description = "Database name"
  type = string
  default = "goalsDB"
}
