output "ec2_role_arn" {
  description = "ARN of ec2 iam role"
  value = aws_iam_role.ec2-role.arn
}

output "ec2_role_name" {
  description = "Name of ec2 iam role"
  value = aws_iam_role.ec2-role.name
}

output "ec2_instance_profile_arn" {
  description = "ARN of ec2 instance profile"
  value = aws_iam_instance_profile.ec2_profile.arn
}

output "ec2_instance_profile_name" {
  description = "ARN of ec2 instance profile"
  value = aws_iam_instance_profile.ec2_profile.name
}
