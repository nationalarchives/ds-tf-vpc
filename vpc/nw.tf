# ------------------------------------------------------------------------------
# building vpc and all required subnets, NAT, internet gateway
# ------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name        = "${var.environment}_vpc"
        environment = var.environment
        Terraform   = "True"
    }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.tna_vpc.id

    tags = {
        Name        = "${var.environment}-igw"
        environment = var.environment
        Terraform   = "True"
    }
}

# EIP and NAT instance for NATting the private subnet when accessing internet.
resource "aws_eip" "nat" {
    vpc = true

    tags = {
        environment = var.environment
        Terraform   = "True"
        Description = "eip for nat gateway"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_1a.id
}

# ------------------------------------------------------------------------------
# subnets
# ------------------------------------------------------------------------------
# public subnets
resource "aws_subnet" "public_1a" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.public_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = true

    tags = {
        Name        = "public_subnet_1a-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_subnet" "public_1b" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.public_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = true

    tags = {
        Name        = "public_subnet_1b-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}


# private subnets
resource "aws_subnet" "private_1a" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.private_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_subnet_1a-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_subnet" "private_1b" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.private_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_subnet_1b-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

# DB subnets
resource "aws_subnet" "private_db_1a" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.private_db_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_db_subnet_1a-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_subnet" "private_db_1b" {
    vpc_id            = aws_vpc.tna_vpc.id
    cidr_block        = var.private_db_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_db_subnet_1b-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

# DB Subnet Group for launching RDS instances
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "tna-db_subnet_group_${var.environment}"

    subnet_ids = [
        aws_subnet.private_db_1a.id,
        aws_subnet.private_db_1b.id]

    tags = {
        Name      = "${var.environment}- DB Subnet Group"
        Terraform = "True"
    }
}
