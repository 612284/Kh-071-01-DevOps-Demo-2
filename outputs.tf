output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_id" {
  description = "The ID of the VPC"
  value       = module.vpc.public_subnets_id
}

output "private_subnets_id" {
  description = "The ID of the VPC"
  value       = module.vpc.private_subnets_id
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}
output "target_group_arns" {
  value = module.alb.target_group_arns
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
