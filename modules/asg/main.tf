data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    yum install -y amazon-efs-utils
amazon-linux-extras install -y nginx1

mkdir -p /var/www/efs
mount -t efs ${var.efs_dns_name}:/ /var/www/efs || true

cat > /usr/share/nginx/html/index.html <<HTML
<html>
  <body>
    <h1>OK - Arquitetura completa</h1>
    <p>Hostname: $(hostname)</p>
    <p>EFS: ${var.efs_dns_name}</p>
    <p>DB endpoint: ${var.db_endpoint}</p>
    <p>DB name: ${var.db_name}</p>
  </body>
</html>
HTML

systemctl enable nginx
systemctl start nginx
  EOF
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ami.al2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.sg_app_id]

  user_data = base64encode(local.user_data)
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.name_prefix}-asg"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids

  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }
}