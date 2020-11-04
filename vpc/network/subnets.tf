# ------------------------------------------------------------------------------
# subnets
# ------------------------------------------------------------------------------
# public subnets
resource "aws_subnet" "public_1a" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = true

    tags = {
        Name        = "public_subnet_1a-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_subnet" "public_1b" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = true

    tags = {
        Name        = "public_subnet_1b-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}


# private subnets
resource "aws_subnet" "private_1a" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_subnet_1a-${var.environment}"
        environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_subnet" "private_1b" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_subnet_1b-${var.environment}"
        environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# DB subnets
resource "aws_subnet" "private_db_1a" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_db_subnet_1a
    availability_zone = "${var.vpc_region}a"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_db_subnet_1a-${var.environment}"
        environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_subnet" "private_db_1b" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_db_subnet_1b
    availability_zone = "${var.vpc_region}b"

    map_public_ip_on_launch = false

    tags = {
        Name        = "private_db_subnet_1b-${var.environment}"
        environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
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
        Owner     = var.owner
        CreatedBy = var.created_by
    }
}
