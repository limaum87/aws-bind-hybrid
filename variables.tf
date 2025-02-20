variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS profile configured in the credentials file"
  type        = string
  default     = "default"
}

variable "cidr_block" {
  description = "Main CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnets
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "public_availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
}

# Private Subnets
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "private_availability_zones" {
  description = "List of availability zones for the private subnets"
  type        = list(string)
}

# EC2 Instance
variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Key Pair
variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

# VPC and ALB Names
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}


variable "customer_gateway_ip" {
  description = "IP of your Custormer Gateway"
  type        = string
}

variable "destination_cidr_block"{
  description = "CIDR on prem"
  type        = string
}