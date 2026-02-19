variable "environment" {
  description = "Environment Name (eg, dev. stage, prod)"
  type = string
}

variable "project" {
  description = "Project Name"
  type = string
}

variable "ami_id" {
  description = "Amazon Machine Image for Ubuntu"
  type = string
  default = ""
}

variable "instance_type" {
  description = "Instance type for backend asg"
  type = string
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key name for login"
  type = string
}

variable "iam_instance_profile" {
  description = "Iam instance profile for ec2"
  type = string
}

variable "security_group_id" {
  description = "Security group id for backend"
  type = string
}

variable "docker_image" {
  description = "Full docker image of application"
  type = string
}

variable "dockerhub_username" {
  description = "Docker Hub username (optional for public images)"
  type        = string
  default     = ""
}

variable "dockerhub_password" {
  description = "Docker Hub password or access token (optional for public images)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_secret_arn" {
  description = "ARN of Secrets Manager secret containing database credentials"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "List of Target Group ARNs to attach to the ASG"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "alarm_actions" {
  description = "List of ARNs for alarm actions (e.g., SNS topics)"
  type        = list(string)
  default     = []
}