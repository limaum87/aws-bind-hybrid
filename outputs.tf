output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID da subnet privada"
  value       = module.vpc.private_subnet_id
}

output "security_group_id" {
  description = "ID do Security Group criado"
  value       = module.security_group.security_group_id
}

output "ec2_instance_id" {
  description = "ID da instância EC2 criada"
  value       = module.ec2_instance.instance_id
}

output "ec2_instance_private_ip" {
  description = "IP privado da instância EC2"
  value       = module.ec2_instance.private_ip
}
