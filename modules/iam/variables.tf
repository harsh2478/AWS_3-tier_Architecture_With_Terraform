variable "environment" {
    description = "Environment Name (eg: dev, stage, prod)" 
    type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "tags" {
  description = "Tags for all resources"
  type = map(string)
  default = {}
}

variable "secret_arns" {
  description = "ARNs of Secret stored in Secret Manager"
  type = list(string)
}

