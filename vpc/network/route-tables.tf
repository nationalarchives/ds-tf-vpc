# ------------------------------------------------------------------------------
# route tables and routes
# ------------------------------------------------------------------------------
# public
# ------------------------------------------------------------------------------
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Account     = var.account
        Name        = "public-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_route" "public_route_internet" {
    route_table_id = aws_route_table.public_rt.id
    gateway_id     = aws_internet_gateway.igw.id

    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rt_assoc" {
    count = length(aws_subnet.public_subs)

    subnet_id      = aws_subnet.public_subs[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

# ------------------------------------------------------------------------------
# private
# ------------------------------------------------------------------------------
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Account     = var.account
        Name        = "private-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.private_rt.id
    nat_gateway_id = aws_nat_gateway.nat_gateway.id

    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_rt_assoc" {
    count = length(aws_subnet.private_subs)

    subnet_id      = aws_subnet.private_subs[count.index].id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_assoc" {
    count = length(aws_subnet.private_db_subs)

    subnet_id      = aws_subnet.private_db_subs[count.index].id
    route_table_id = aws_route_table.private_rt.id
}
