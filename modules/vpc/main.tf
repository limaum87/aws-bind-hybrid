resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
 tags = merge(
    var.tags,
    {
      Name = var.vpc_name  # Nome da VPC
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-public-subnet-${count.index + 1}" }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.private_availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-private-subnet-${count.index + 1}" }
  )
}


# Internet Gateway (para a subnet pública)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, { Name = "${var.vpc_name}-internet-gateway" })
}


# Criação do NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # Subnet pública onde o NAT Gateway vai ficar
  tags = merge(var.tags, { Name = "${var.vpc_name}-nat-gateway" })
}

# Alocação do IP Elastic para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"  # Alteração de 'vpc = true' para 'domain = "vpc"'
  tags = merge(var.tags, { Name = "${var.vpc_name}-eip-nat" })
}


# Tabela de Rotas para as subnets públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # Rota para a internet via Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { 
    Name = "${var.vpc_name}-public-route-table"  # Nome da tabela de rotas públicas
  })
}

# Associação da Tabela de Rotas com as Subnets Públicas
resource "aws_route_table_association" "public" {
  for_each      = { for idx, subnet_id in aws_subnet.public : idx => subnet_id.id } # Itera sobre todas as subnets públicas
  subnet_id     = each.value
  route_table_id = aws_route_table.public.id
}

# Tabela de Rotas para as subnets privadas (via NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  # Rota para a internet via NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, { 
    Name = "${var.vpc_name}-private-route-table"  # Nome da tabela de rotas privadas
  })
}

# Associação da Tabela de Rotas com as Subnets Privadas
resource "aws_route_table_association" "private" {
  for_each      = { for idx, subnet_id in aws_subnet.private : idx => subnet_id.id } # Itera sobre todas as subnets privadas
  subnet_id     = each.value
  route_table_id = aws_route_table.private.id
}

