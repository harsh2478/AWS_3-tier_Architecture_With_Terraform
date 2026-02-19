variable "environment" {
  description = "Environment name (eg: dev, stage, prod)"
  type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "region" {
  description = "Region Name"
  type = string
}

variable "aws_ami" {
  description = "Amazon machine image for ubuntu"
  type = string
  default = ""
}

variable "instance_type" {
  description = "Instance type for frontend server"
  type = string
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH Key Name"
  type = string
}

variable "iam_instance_profile" {
  description = "Instane Profile Name for EC2"
  type = string
}

variable "security_group_id" {
  description = "Security Group for Frontend Server"
  type = string
}

variable "docker_image" {
  description = "Full docker Image Name for Application (eg, username/image:tag)"
  type = string
}

variable "dockerhub_username" {
  description = "Dockerhub Username (optional for public images)"
  type = string
  default = ""
}

variable "dockerhub_password" {
    description = "Dockerhub Password (optional for public images)"
    type = string
    sensitive = true
    default = ""  
}

variable "backend_internal_url" {
  description = "Internal URL for backend service"
  type        = string
}

variable "tags" {
  description = "common tags for all reources"
  type = map(string)
  default = {}
}

variable "min_size" {
  description = "Minimum number of instances"
  type = number
  default = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type = number
  default = 4
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type = number
  default = 2
}

variable "subnet_ids" {
  description = "List of subnet Ids for ASG"
  type = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type = string
}

variable "alarm_actions" {
  description = "List of arns for alarm actions (eg, sns topic)"
  type = list(string)
  default = []
}
