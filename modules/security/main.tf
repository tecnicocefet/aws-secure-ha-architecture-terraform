# Bastion: SSH somente do seu IP
resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-sg-bastion"
  description = "SSH only from my IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB público: HTTP aberto (p/ lab)
resource "aws_security_group" "alb" {
  name   = "${var.name_prefix}-sg-alb"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# APP (EC2 privadas): recebe HTTP apenas do SG do ALB; SSH apenas do bastion
resource "aws_security_group" "app" {
  name   = "${var.name_prefix}-sg-app"
  vpc_id = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EFS: NFS 2049 apenas das EC2 app
resource "aws_security_group" "efs" {
  name   = "${var.name_prefix}-sg-efs"
  vpc_id = var.vpc_id

  ingress {
    description     = "NFS from APP"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS: porta 3306 (mysql) apenas das EC2 app
resource "aws_security_group" "rds" {
  name   = "${var.name_prefix}-sg-rds"
  vpc_id = var.vpc_id

  ingress {
    description     = "MySQL from APP"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}