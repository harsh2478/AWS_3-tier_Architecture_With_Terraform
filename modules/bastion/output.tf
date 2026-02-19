output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Public IP of Bastion Host"
  value = aws_instance.bastion.private_ip
}