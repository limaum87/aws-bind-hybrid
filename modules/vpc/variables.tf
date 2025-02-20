variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "public_availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "private_availability_zones" {
  description = "List of availability zones for the private subnets"
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources in the VPC module"
  type        = map(string)
  default     = {}
}
