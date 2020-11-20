# ------------------------------------------------------------------------------
# building vpc and all required subnets, NAT, internet gateway
# ------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Account     = var.account
        Name        = "${var.account}-vpc"
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Account     = var.account
        Name        = "${var.environment}-igw"
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# EIP and NAT instance for NATting the private subnet when accessing internet.
resource "aws_eip" "nat" {
    vpc = true

    tags = {
        Account     = var.account
        Environment = var.environment
        Terraform   = "true"
        Description = "eip for nat gateway"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_subs[keys(aws_subnet.public_subs)[0]].id
}
