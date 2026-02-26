variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "sso-joao"
}

variable "name_prefix" {
  type    = string
  default = "arquitetura-completa"
}

variable "my_ip_cidr" {
  type        = string
  description = "Seu IPv4 público/32 para SSH no bastion"
}

variable "key_name" {
  type        = string
  description = "Nome do Key Pair existente na AWS (ex: terraform)"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

# EC2
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# RDS (barato e suficiente p/ lab)
variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "adminuser"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Senha do RDS (mín 8 chars). NÃO suba isso no Git."
}

# CloudFront
variable "enable_route53" {
  type    = bool
  default = false # deixei false para evitar custo/complexidade
}