resource "aws_db_subnet_group" "db_subnet" {
  name = "${var.environment}-${var.project}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-db-subnet-group"
    }
  )
}

resource "aws_db_parameter_group" "db_parameter" {
  name = "${var.environment}-${var.project}-pg15"
  family = "postgres15"

  parameter {
    name = "log_connections"
    value = "1"
  }

  parameter {
    name = "log_disconnections"
    value = "1"
  }

  parameter {
    name = "log_duration"
    value = "1"
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-pg15"
    }
  )
}

resource "aws_db_instance" "main" {
  identifier = "${var.environment}-${var.project}-postgres"
  engine = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type = "gp3"
  storage_encrypted = true

  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  port = 5432

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  parameter_group_name = aws_db_parameter_group.db_parameter.name

  multi_az = var.multi_az
  publicly_accessible = false
  availability_zone = var.multi_az ? null : var.availability_zone

  backup_retention_period = var.backup_retention_period
  backup_window = "03:00-04:00"
  maintenance_window = "mon:04:00-mon:05:00"

  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-${var.project}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null
  auto_minor_version_upgrade = true
  deletion_protection = var.deletion_protection

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-postgres"
    }
  )
}

resource "aws_iam_role" "rds_monitoring" {
    count = var.monitoring_interval > 0 ? 1 : 0
    name = "${var.environment}-${var.project}-rds-monitoring-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "monitoring.rds.amazonaws.com"
                }
            }
        ]
    })
    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
    count = var.monitoring_interval > 0 ? 1 : 0
    role = aws_iam_role.rds_monitoring[count.index].name
    policy_arn = "arn:aws:iam::aws:policy/servie-role/AmazonRDSEnhancedMonitoringRole"
}