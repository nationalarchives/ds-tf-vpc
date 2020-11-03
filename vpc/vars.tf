variable "vpc_cidr" {
  description = "This is the CIDR block of the VPC to be created"
}

variable "vpc_region" {
  description = "Region for VPC"
}

variable "Environment" {
  description = "Environment for these resources - will be prepended to resources"
}

variable "Public-subnet-1a" {
  description = "CIDR block for Public Subnet in eu-west-1a"
}

variable "Public-subnet-1b" {
  description = "CIDR block for Public Subnet in eu-west-1b"
}

variable "Private-subnet-1a" {
  description = "CIDR block for Private Subnet in eu-west-1a"
}

variable "Private-subnet-1b" {
  description = "CIDR block for Private Subnet in eu-west-1b"
}

variable "Private-db-subnet-1a" {
  description = "CIDR block for Private Database Subnet in eu-west-1a"
}

variable "Private-db-subnet-1b" {
  description = "CIDR block for Private Database Subnet in eu-west-1b"
}

variable "intersite-computers" {
  description = "Onsite computers for connection over VPN"
}

variable "browse_access" {
  description = "CIDR block for browse access - can close dev/test if needed"
}

variable "tna_dev_network" {
  description = "CIDR Block of TNA Dev IPs"
}

variable "tna_soaapp_network" {
  description = "CIDR Block of TNA Soaapp IPs"
  default = "172.31.2.0/24"
}

variable "ssis_server" {
  description = "IP address of the SSIS server in CIDR notation"
}

variable "lobapp_servers" {
  description = "IP address(es) of the lobapp servers in CIDR notation"
}

locals {
  Private-db-subnet = ["${var.Private-db-subnet-1a}","${var.Private-db-subnet-1b}"]
  Private-subnet = ["${var.Private-subnet-1a}","${var.Private-subnet-1b}"]
  Public-subnet = ["${var.Public-subnet-1a}","${var.Public-subnet-1b}"]
}

