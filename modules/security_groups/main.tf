resource "aws_security_group" "alb" {
  name = "${var.environment}-${var.project}-alb-sg"
  vpc_id = var.vpc_id
  description = "Security Group for Application Load Balancer (Public)"

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all Outbound Traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-alb-sg"
    }
  )
}

resource "aws_security_group" "bastion" {
  name = "${var.environment}-${var.project}-bastion-sg"
  vpc_id = var.vpc_id
  description = "Security Group for Bastion Host"

  ingress {
    description = "Allowed CIDRs into Bastions"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-bastion-sg"
    }
  )
}

resource "aws_security_group" "frontend" {
  name = "${var.environment}-${var.project}-frontend-sg"
  description = "Security Group for Frontend Application Servers"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "SSH from Bastion Host"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-frontend-sg"
    }
  )
}


resource "aws_security_group" "internal-alb" {
  name = "${var.environment}-${var.project}-internal-alb-sg"
  vpc_id = var.vpc_id
  description = "Security Group for Internal Application Load Balancer"

  ingress {
    description = "HTTP from frontend"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    description = "Allow all Outbound Traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-internal-alb-sg"
    }
  )
}

resource "aws_security_group" "backend" {
  name = "${var.environment}-${var.project}-backend-sg"
  description = "Security Group for Backend Application Servers"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from Internal ALB"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.internal-alb.id]
  }

  ingress {
    description = "SSH from Bastion Host"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-backend-sg"
    }
  )
}

resource "aws_security_group" "rds" {
  name = "${var.environment}-${var.project}-rds-sg"
  vpc_id = var.vpc_id
  description = "Security Group for RDS PostgresSQL database"

  ingress {
    description = "HTTP from frontend"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    description = "Allow all Outbound Traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = []
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-rds-sg"
    }
  )
}