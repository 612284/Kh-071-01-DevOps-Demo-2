provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "alb" {
  source = "./modules/alb"

  private_subnets_id   = module.vpc.private_subnets_id
  public_subnets_id    = module.vpc.public_subnets_id
  vpc_id               = module.vpc.vpc_id
  sg_alb_ingress_ports = var.sg_alb_ingress_ports
  depends_on           = [module.vpc]
}

module "asg" {
  source = "./modules/asg"

  private_subnets_id   = module.vpc.private_subnets_id
  public_subnets_id    = module.vpc.public_subnets_id
  vpc_id               = module.vpc.vpc_id
  target_group_arns    = module.alb.target_group_arns
  generated_key_name   = module.key.generated_key_name
  aws_ami_id           = data.aws_ami.latest_ubuntu.id
  sg_asg_ingress_ports = var.sg_asg_ingress_ports
  instance_type        = var.instance_type
  depends_on           = [module.vpc, module.key]
}

module "bastion" {
  source = "./modules/bastion"

  private_subnets_id   = module.vpc.private_subnets_id
  public_subnets_id    = module.vpc.public_subnets_id
  vpc_id               = module.vpc.vpc_id
  private_key_pem      = module.key.private_key_pem
  aws_ami_id           = data.aws_ami.latest_ubuntu.id
  sg_bas_ingress_ports = var.sg_bas_ingress_ports
  key_name_bastion     = var.key_name_bastion
  instance_type        = var.instance_type
  depends_on           = [module.vpc, module.key]
}

module "key" {
  source = "./modules/key"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
