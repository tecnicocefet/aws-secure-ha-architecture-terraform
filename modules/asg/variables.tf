variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "sg_app_id" { type = string }
variable "sg_bastion_id" { type = string }
variable "target_group_arn" { type = string }

variable "key_name" { type = string }
variable "instance_type" { type = string }

variable "efs_dns_name" { type = string }
variable "db_endpoint" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}