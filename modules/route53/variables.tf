variable "zone_name" {
  description = "O nome da zona do Route 53"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde a zona será associada"
  type        = string
}