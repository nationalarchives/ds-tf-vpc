output "db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.id
}

output "id" {
    value = aws_vpc.vpc.id
}

output "region" {
    value = var.vpc_region
}

output "vpc_cidr" {
    value = aws_vpc.vpc.cidr_block
}

output "publicsubnet_ids" {
    value = [
        aws_subnet.public_1a.id,
        aws_subnet.public_1b.id]
}

output "privatesubnet_ids" {
    value = [
        aws_subnet.private_1a.id,
        aws_subnet.private_1b.id]
}

output "public_route_table" {
    value = aws_route_table.public_route_table.id
}

output "private_route_table" {
    value = aws_route_table.private_route_table.id
}
