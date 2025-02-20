output "instance_id" {
  description = "ID da instância criada"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Endereço IP público da instância"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Endereço IP privado da instância"
  value       = aws_instance.this.private_ip
}