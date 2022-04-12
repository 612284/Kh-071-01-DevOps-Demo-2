variable "security_group_id" {
  description = "security group id"
  type        = string
  default     = ""
}
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

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "sg_alb_ingress_ports" {
  type    = list(string)
  default = []
}
