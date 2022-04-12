variable "region" {
  description = "region"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}
variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = ""
}
variable "key_name_bastion" {
  description = "key_name_bastion"
  type        = string
  default     = ""
}

variable "sg_alb_ingress_ports" {
  type    = list(string)
  default = []
}

variable "sg_asg_ingress_ports" {
  type    = list(string)
  default = []
}
variable "sg_bas_ingress_ports" {
  type    = list(string)
  default = []
}
