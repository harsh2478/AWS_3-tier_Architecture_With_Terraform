output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value = aws_autoscaling_group.frontend.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value = aws_autoscaling_group.frontend.name
}

output "asg_arn" {
  description = "ARN of the AutoScaling Group"
  value = aws_autoscaling_group.frontend.arn
}

output "launch_template_id" {
  description = "ID of the Frontend Launch Template"
  value = aws_launch_template.Frontend.id
}

output "launch_template_latest_version" {
  description = "Latest Version of the Launch Template"
  value = aws_launch_template.Frontend.latest_version
}