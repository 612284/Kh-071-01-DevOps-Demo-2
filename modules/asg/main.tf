resource "aws_autoscaling_group" "ubuntu-ec2" {
  launch_configuration = aws_launch_configuration.ubuntu-ec2.name
  vpc_zone_identifier  = var.private_subnets_id

  target_group_arns = [var.target_group_arns]
  health_check_type = "ELB"

  min_size         = 1
  max_size         = 2
  desired_capacity = 2

  tag {
    key                 = "Name"
    value               = "asg ubuntu ec2"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "ubuntu-ec2" {
  image_id        = var.aws_ami_id
  instance_type   = var.instance_type
  key_name        = var.generated_key_name
  security_groups = [aws_security_group.instance.id]
  user_data       = <<EOF
#!/bin/bash
sudo apt -y update
sudo apt install  -y apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo chmod 777 /var/www/html/index.html
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo chmod 755 /var/www/html/index.html
sudo systemctl restart apache2
EOF
  # Required when using launch configuration with auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  vpc_id = var.vpc_id
  name   = "instance security group"
  dynamic "ingress" {
    for_each = var.sg_asg_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "instance security group"
  }
}
