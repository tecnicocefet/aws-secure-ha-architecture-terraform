resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-dbsubnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier        = "${var.name_prefix}-rds"
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_encrypted = true
  multi_az          = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [var.sg_rds_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible = false
  skip_final_snapshot = true
}