 variable "name" {
  description = "Prefixo do nome para o ALB e seus recursos"
  type        = string
}

variable "vpc_id" {
  description = "O ID da VPC onde o ALB será criado"
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de subnets públicas onde o ALB será criado"
  type        = list(string)
}

variable "instance_ids" {
  description = "Lista de IDs das instâncias EC2 a serem adicionadas ao Target Group"
  type        = list(string)
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
}

