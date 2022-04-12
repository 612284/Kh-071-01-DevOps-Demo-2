output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "Domain name ALB"
}
output "target_group_arns" {
  value       = aws_lb_target_group.asg-target-group.arn
  description = ""
}
