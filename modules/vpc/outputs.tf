# Saída para o ID da VPC
output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}


# Saída para o ID do Internet Gateway
output "internet_gateway_id" {
  description = "ID do Internet Gateway associado à VPC"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Exporta apenas o primeiro ID da subnet pública (se necessário)
output "public_subnet_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public[0].id
}

# Exporta apenas o primeiro ID da subnet privada (se necessário)
output "private_subnet_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private[0].id
}

# Módulo VPC - Exportando a ID da Tabela de Rotas
output "route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
  description = "ID da tabela de rotas para as subnets privadas"
}

output "public_route_table_id" {
  value = aws_route_table.public.id
  description = "ID da tabela de rotas para as subnets privadas"
}