variable "ami" {
  description = "ID da AMI para a instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Se a instância terá um IP público associado"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Nome da Key Pair para acesso SSH"
  type        = string
}

variable "security_group_ids" {
  description = "Lista de IDs dos Security Groups associados à instância"
  type        = list(string)
}

variable "tags" {
  description = "Tags para a instância"
  type        = map(string)
}

variable "user_data" {
  description = "Script de inicialização (user data)"
  type        = string
  default     = ""
}