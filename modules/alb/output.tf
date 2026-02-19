output "alb_id" {
  description = "ALB ID"
  value = aws_alb.main.id
}

output "alb_arn" {
  description = "ARN of the ALB"
  value = aws_alb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value = aws_alb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the alb"
  value = aws_alb.main.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value = aws_alb_target_group.main.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value = aws_alb_target_group.main.name
}

output "http_listener_arn" {
  description = "ARN of HTTP Listener"
  value = aws_alb_listener.main.arn
}
