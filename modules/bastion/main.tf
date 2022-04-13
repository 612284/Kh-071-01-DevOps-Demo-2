resource "aws_instance" "bastion" {
  ami                    = var.aws_ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name_bastion
  subnet_id              = var.public_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  user_data              = data.template_file.user_data.rendered
  # private_ip           = "10.0.101.100"
  tags = {
    Name = "bastion"
  }
}

data "template_file" "user_data" {
  template = templatefile("modules/bastion/user_data.tftpl", {
    private_key_pem = var.private_key_pem
  })
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id
  name   = "bastion security group"
  dynamic "ingress" {
    for_each = var.sg_bas_ingress_ports
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
    Name = "bastion security group"
  }
}
