# ------------------------------------------------------------------------------
# subnets
# ------------------------------------------------------------------------------
# public
# ------------------------------------------------------------------------------
resource "aws_subnet" "public_subs" {
    count = length(var.public_subnets)

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnets[count.index]["cidr"]
    availability_zone = var.public_subnets[count.index]["az"]

    map_public_ip_on_launch = true

    tags = {
        Account     = var.account
        Name        = var.public_subnets[count.index]["name"]
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# ------------------------------------------------------------------------------
# private subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "private_subs" {
    count = length(var.private_subnets)

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnets[count.index]["cidr"]
    availability_zone = var.private_subnets[count.index]["az"]

    map_public_ip_on_launch = false

    tags = {
        Account     = var.account
        Name        = var.private_subnets[count.index]["name"]
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# ------------------------------------------------------------------------------
# db subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "private_db_subs" {
    count = length(var.private_db_subnets)

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_db_subnets[count.index]["cidr"]
    availability_zone = var.private_db_subnets[count.index]["az"]

    map_public_ip_on_launch = false

    tags = {
        Account     = var.account
        Name        = var.private_db_subnets[count.index]["name"]
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}
