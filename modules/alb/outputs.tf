output "alb_dns_name" {
  description = "DNS público do ALB"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "ID do Security Group do ALB"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN do Target Group"
  value       = aws_lb_target_group.this.arn
}
