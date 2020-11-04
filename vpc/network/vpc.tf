# ------------------------------------------------------------------------------
# building vpc and all required subnets, NAT, internet gateway
# ------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name        = "${var.environment}_vpc"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name        = "${var.environment}-igw"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# EIP and NAT instance for NATting the private subnet when accessing internet.
resource "aws_eip" "nat" {
    vpc = true

    tags = {
        Environment = var.environment
        Terraform   = "True"
        Description = "eip for nat gateway"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_1a.id
}
