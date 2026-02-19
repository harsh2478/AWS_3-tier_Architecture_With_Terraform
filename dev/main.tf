data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "vpc" {
  source             = "../modules/vpc"
  environment        = var.environment
  project            = var.project
  vpc_cidr_block     = var.vpc_cidr_block
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  frontend_subnets   = var.frontend_subnets
  Backend_subnets    = var.Backend_subnets
  database_subnets   = var.database_subnets
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
  tags               = var.tags
}

module "security_groups" {
  source            = "../modules/security_groups"
  vpc_id            = module.vpc.vpc_id
  environment       = var.environment
  project           = var.project
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}



module "iam" {
  source      = "../modules/iam"
  project     = var.project
  environment = var.environment
  secret_arns = ["*"]
}

module "rds" {
  source = "../modules/rds"

  environment             = var.environment
  project                 = var.project
  subnet_ids              = module.vpc.database_subnet_ids
  security_group_id       = module.security_groups.rds_sg_id
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  engine_version          = var.db_engine_version
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = random_password.db_password.result
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  tags = var.tags
}

module "secrets" {
  source      = "../modules/secrets"
  project     = var.project
  environment = var.environment
  db_username = var.db_username
  db_password = random_password.db_password.result
  db_port     = module.rds.db_port
  db_host     = module.rds.db_address
  db_name     = var.db_name

  tags = var.tags
}

module "bastion" {
  source               = "../modules/bastion"
  environment          = var.environment
  project              = var.project
  instance_type        = var.bastion_instance_type
  key_name             = var.ssh_key_name
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_id    = module.security_groups.bastion_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile_name

  tags = var.tags
}

module "alb" {
  source            = "../modules/alb"
  environment       = var.environment
  project           = var.project
  name_prefix       = "public-"
  internal          = false
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_sg_id
  target_group_port = 3000

  tags = var.tags
}

module "internal_alb" {
  source            = "../modules/alb"
  environment       = var.environment
  project           = var.project
  name_prefix       = "private-"
  internal          = true
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.frontend_subnet_ids
  security_group_id = module.security_groups.internal_alb_sg_id
  target_group_port = 8080

  tags = var.tags
}

module "frontend_asg" {
  source               = "../modules/frontend_asg"
  environment          = var.environment
  project              = var.project
  instance_type        = var.frontend_instance_type
  key_name             = var.ssh_key_name
  region               = var.region
  iam_instance_profile = module.iam.ec2_instance_profile_name
  security_group_id    = module.security_groups.frontend_sg_id
  subnet_ids           = module.vpc.frontend_subnet_ids
  target_group_arn     = module.alb.target_group_arn
  min_size             = var.frontend_min_size
  max_size             = var.frontend_max_size
  desired_capacity     = var.frontend_desired_capacity
  docker_image         = var.frontend_docker_image
  backend_internal_url = module.internal_alb.alb_dns_name

  depends_on = [module.alb, module.rds, module.internal_alb]
  tags       = var.tags
}

module "backend_asg" {
  source = "../modules/backend_asg"

  environment          = var.environment
  project              = var.project
  region               = var.region
  instance_type        = var.backend_instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = module.iam.ec2_instance_profile_name
  security_group_id    = module.security_groups.backend_sg_id
  subnet_ids           = module.vpc.backend_subnet_ids
  target_group_arns    = [module.internal_alb.target_group_arn]
  min_size             = var.backend_min_size
  max_size             = var.backend_max_size
  desired_capacity     = var.backend_desired_capacity

  docker_image       = var.backend_docker_image
  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub_password
  db_secret_arn      = module.secrets.db_secret_arn

  tags = var.tags

  depends_on = [module.rds, module.secrets]
}