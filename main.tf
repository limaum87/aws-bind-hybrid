provider "aws" {
  region  = var.region
  profile = var.profile
}

# Módulo da VPC
module "vpc" {
  source = "./modules/vpc"
  cidr_block                 = var.cidr_block
  public_subnet_cidrs        = var.public_subnet_cidrs
  public_availability_zones  = var.public_availability_zones
  private_subnet_cidrs       = var.private_subnet_cidrs
  private_availability_zones = var.private_availability_zones
  vpc_name                   = var.vpc_name
  tags                       = var.tags
}


# Módulo do Security Group
module "security_group" {
  source               = "./modules/security_group"
  name                 = "allow-80"
  description          = "Allow HTTP traffic on port 80"
  vpc_id               = module.vpc.vpc_id
  ingress_from_port    = 80
  ingress_to_port      = 80
  protocol             = "tcp"
  ingress_cidr_blocks  = ["0.0.0.0/0"] # Permite para todos
  tags                 = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}

module "security_group2" {
  source               = "./modules/security_group"
  name                 = "allow-22"
  description          = "Allow SSH traffic on port 22"
  vpc_id               = module.vpc.vpc_id
  ingress_from_port    = 22
  ingress_to_port      = 22
  protocol             = "tcp"
  ingress_cidr_blocks  = ["0.0.0.0/0"] # Permite para todos
  tags                 = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}

module "allow_icmp" {
  source               = "./modules/security_group"
  name                 = "allow-icmp"
  description          = "Allow ICMP traffic"
  vpc_id               = module.vpc.vpc_id
  ingress_from_port    = -1                   # -1 para permitir todos os tipos de ICMP
  ingress_to_port      = -1                   # -1 para permitir todos os tipos de ICMP
  protocol             = "icmp"               # Especifica o protocolo ICMP
  ingress_cidr_blocks  = ["0.0.0.0/0"]       # Permite para todos
  tags                 = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}
# Módulo da Instância EC2
module "ec2_instance" {
  source                    = "./modules/ec2"
  ami                       = var.ami
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.private_subnet_id # Subnet privada
  associate_public_ip_address = false # Sem IP público
  key_name                  = module.key_pair.key_pair_name
  security_group_ids        = [module.security_group.security_group_id,module.security_group2.security_group_id,module.allow_icmp.security_group_id]
  tags                      = {
    Name        = "Example EC2 Instance"
    Environment = "Development"
  }
  user_data = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
  EOT
}

# Módulo do Key Pair
module "key_pair" {
  source     = "./modules/keypair"
  key_name   = var.key_name
  public_key = var.public_key_path # Arquivo contendo a chave pública
}

# Configuração do VPN Gateway
resource "aws_vpn_gateway" "vpg" {
  vpc_id             = module.vpc.vpc_id
  tags = {
    Name = "VPNGateway"
  }
}

# Configuração do Customer Gateway
resource "aws_customer_gateway" "cgw" {
  ip_address = var.customer_gateway_ip # IP da sua rede on-premise
  type = "ipsec.1"

  tags = {
    Name = "CustomerGateway"
  }
}

# Configuração da VPN Connection com rotas estáticas
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  vpn_gateway_id      = aws_vpn_gateway.vpg.id
  type                = "ipsec.1"
  static_routes_only  = true  # Indica que vamos usar rotas estáticas
  # Definindo as rotas estáticas


  tags = {
    Name = "SiteToSiteVPN"
  }
  
}

# Rota Estática na AWS para enviar o tráfego para a rede on-premise
resource "aws_route" "route_to_onprem" {
  route_table_id         = module.vpc.private_route_table_id  # Usando o output do módulo VPC
  destination_cidr_block = var.destination_cidr_block  # Rede on-premise
  gateway_id             = aws_vpn_gateway.vpg.id
}



# Chama o módulo do Route 53 para criar a zona privada
module "route53" {
  source   = "./modules/route53"    # Caminho para o módulo
  zone_name = "accept.cloud"        # Nome da zona
  vpc_id    = module.vpc.vpc_id      # ID da VPC criada no módulo VPC
}

# Criando o Resolver Endpoint para encaminhar as consultas para a rede on-premise
resource "aws_route53_resolver_endpoint" "resolver_endpoint" {
  direction             = "OUTBOUND"  # Enviar as requisições DNS para a rede on-premise
  security_group_ids    = [module.security_group.security_group_id]

  ip_address {
    subnet_id = module.vpc.public_subnet_id  # IPs públicos para o resolver
  }

  ip_address {
    subnet_id = module.vpc.private_subnet_id  # IPs privados para o resolver
  }

  tags = {
    Name = "AWSResolverEndpoint"
  }
}

# Regra de DNS para encaminhar consultas da AWS para a rede on-premise
resource "aws_route53_resolver_rule" "aws_to_onprem" {
  domain_name           = "accept.onpremise"  # Domínio da rede on-premise
  rule_type             = "FORWARD"  # Define o tipo de regra como "FORWARD"
  target_ip {
    ip = var.onprem_dns_ip  # IP do DNS da rede on-premise
  }
  resolver_endpoint_id   = aws_route53_resolver_endpoint.resolver_endpoint.id
  name                   = "forward-to-onprem"
  tags = {
    Name = "AWSDNSForwarderToOnPrem"
  }
}
