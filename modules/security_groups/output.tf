output "alb_sg_id" {
  description = "Application Load Balancer Security Group ID"
  value = aws_security_group.alb.id
}

output "frontend_sg_id" {
  description = "Frontend Security Group ID"
  value = aws_security_group.frontend.id
}

output "internal_alb_sg_id" {
  description = "Internal Application Load Balancer Security Group ID"
  value = aws_security_group.internal-alb.id
}

output "backend_sg_id" {
  description = "Backend Security Group ID"
  value = aws_security_group.backend.id
}

output "bastion_sg_id" {
  description = "Bastion Host Seurity Group ID"
  value = aws_security_group.bastion.id
}

output "rds_sg_id" {
  description = "RDS Security Group ID"
  value = aws_security_group.rds.id
}