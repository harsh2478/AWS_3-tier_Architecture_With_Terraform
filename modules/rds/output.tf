output "db_instance_id" {
  description = "ID of the RDS instance"
  value = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value = aws_db_instance.main.arn
}

output "db_endpoint" {
  description = "Connection Endpoint of RDS database"
  value = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance"
  value = aws_db_instance.main.address
}

output "db_name" {
  description = "Name of the RDS Database"
  value = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Database Master Username"
  value = aws_db_instance.main.username
  sensitive = true
}

output "db_subnet_group_name" {
    description = "DB subnet group name"
    value = aws_db_subnet_group.db_subnet.name
}

output "db_port" {
  description = "DataBase Port"
  value = aws_db_instance.main.port
}