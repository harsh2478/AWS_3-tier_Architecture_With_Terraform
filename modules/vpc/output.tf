output "vpc_id" {
  description = "ID of VPC"
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of VPC"
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of Pubic Subnet"
  value = aws_subnet.public[*].id
}

output "frontend_subnet_ids" {
  description = "IDs of Frontend Subnets"
  value = aws_subnet.frontend[*].id
}

output "backend_subnet_ids" {
  description = "IDs of Backend Subnet"
  value = aws_subnet.Backend[*].id
}

output "database_subnet_ids" {
  description = "IDs of Backend Subnet"
  value = aws_subnet.Database[*].id
}

output "Internet_Gateway_id" {
    description = "ID of Internet Gateway"
    value = aws_internet_gateway.main.id
}

output "Nat_Gateway_Public_IP" {
  description = "Public IP of Nat Gatway"
  value = aws_eip.nat[*].public_ip
}