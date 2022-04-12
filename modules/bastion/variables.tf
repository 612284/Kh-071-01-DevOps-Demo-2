variable "public_subnets_id" {
  description = "A list of public subnets id inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets_id" {
  description = "A list of private subnets id inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "aws_ami_id" {
  type    = string
  default = ""
}

variable "private_key_pem" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}
variable "key_name_bastion" {
  type    = string
  default = ""
}

variable "sg_bas_ingress_ports" {
  type    = list(string)
  default = []
}
