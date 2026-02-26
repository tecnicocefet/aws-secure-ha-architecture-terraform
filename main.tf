provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "network" {
  source               = "./modules/network"
  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source      = "./modules/security"
  name_prefix = var.name_prefix
  vpc_id      = module.network.vpc_id
  my_ip_cidr  = var.my_ip_cidr
}

module "bastion" {
  source           = "./modules/bastion"
  name_prefix      = var.name_prefix
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0]
  sg_bastion_id    = module.security.sg_bastion_id
  key_name         = var.key_name
}

module "efs" {
  source             = "./modules/efs"
  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  sg_efs_id          = module.security.sg_efs_id
}

module "rds" {
  source             = "./modules/rds"
  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  sg_rds_id          = module.security.sg_rds_id

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

module "alb" {
  source            = "./modules/alb"
  name_prefix       = var.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  sg_alb_id         = module.security.sg_alb_id
}

module "asg" {
  source             = "./modules/asg"
  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  sg_app_id        = module.security.sg_app_id
  sg_bastion_id    = module.security.sg_bastion_id
  target_group_arn = module.alb.target_group_arn

  key_name      = var.key_name
  instance_type = var.instance_type

  efs_dns_name = module.efs.dns_name
  db_endpoint  = module.rds.db_endpoint
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password
}

module "cdn" {
  source       = "./modules/cdn"
  name_prefix  = var.name_prefix
  alb_dns_name = module.alb.alb_dns_name
}