# ------------------------------------------------------------------------------
# subnets
# ------------------------------------------------------------------------------
# public
# ------------------------------------------------------------------------------
resource "aws_subnet" "public_subs" {
    for_each = var.public_subnets

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = each.value.cidr
    availability_zone = each.value.az

    map_public_ip_on_launch = true

    tags = {
        Account     = var.account
        Name        = each.key
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
    for_each = var.private_subnets

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = each.value.cidr
    availability_zone = each.value.az

    map_public_ip_on_launch = false

    tags = {
        Account     = var.account
        Name        = each.key
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
    for_each = var.private_db_subnets

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = each.value.cidr
    availability_zone = each.value.az

    map_public_ip_on_launch = false

    tags = {
        Account     = var.account
        Name        = each.key
        Environment = var.environment
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}
