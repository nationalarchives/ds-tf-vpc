# ------------------------------------------------------------------------------
# route tables and routes
# ------------------------------------------------------------------------------
# public
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name        = "public-route-table-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_route" "Public_route_internet" {
    route_table_id = aws_route_table.public_route_table.id
    gateway_id     = aws_internet_gateway.igw.id

    destination_cidr_block = "0.0.0.0/0"
}

# private
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name        = "Private-Route-Table-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

resource "aws_route" "Private_route_internet" {
    route_table_id = aws_route_table.private_route_table.id
    nat_gateway_id = aws_nat_gateway.nat_gateway.id

    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
    subnet_id      = aws_subnet.public_1a.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1b" {
    subnet_id      = aws_subnet.public_1b.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_1a" {
    subnet_id      = aws_subnet.private_1a.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_1b" {
    subnet_id      = aws_subnet.private_1b.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_db_1a" {
    subnet_id      = aws_subnet.private_db_1a.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_db_1b" {
    subnet_id      = aws_subnet.private_db_1b.id
    route_table_id = aws_route_table.private_route_table.id
}
