variable "vpc_cidr" {
    description = "This is the CIDR block of the VPC to be created"
}

variable "vpc_region" {
    description = "Region for VPC"
}

variable "environment" {
    description = "Environment for these resources - will be prepended to resources"
}

variable "public_subnet_1a" {
    description = "CIDR block for Public Subnet in eu-west-1a"
}

variable "public_subnet_1b" {
    description = "CIDR block for Public Subnet in eu-west-1b"
}

variable "private_subnet_1a" {
    description = "CIDR block for Private Subnet in eu-west-1a"
}

variable "private_subnet_1b" {
    description = "CIDR block for Private Subnet in eu-west-1b"
}

variable "private_db_subnet_1a" {
    description = "CIDR block for Private Database Subnet in eu-west-1a"
}

variable "private_db_subnet_1b" {
    description = "CIDR block for Private Database Subnet in eu-west-1b"
}

variable "intersite_computers" {
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
    default     = "172.31.2.0/24"
}

variable "ssis_server" {
    description = "IP address of the SSIS server in CIDR notation"
}

variable "lobapp_servers" {
    description = "IP address(es) of the lobapp servers in CIDR notation"
}

locals {
    private_db_subnets = [
        "${var.private_db_subnet_1a}",
        "${var.private_db_subnet_1b}"]

    private_subnets = [
        "${var.private_subnet_1a}",
        "${var.private_subnet_1b}"]


    public_subnets = [
        "${var.public_subnet_1a}",
        "${var.public_subnet_1b}"]
}
