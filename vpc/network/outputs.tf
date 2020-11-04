output "db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.id
}

output "vpc" {
    value = aws_vpc.vpc.id
}

output "vpc_cidr" {
    description = "cidr block of this vpc"
    value       = aws_vpc.vpc.cidr_block
}

output "publicsubnets" {
    value = [
        aws_subnet.public_1a.id,
        aws_subnet.public_1b.id]
}

output "privatesubnets" {
    value = [
        aws_subnet.private_1a.id,
        aws_subnet.private_1b.id]
}

output "public_route_table" {
    description = "public route table for peering stuff"
    value       = aws_route_table.public_route_table.id
}

output "private_route_table" {
    description = "private route table for peering stuff"
    value       = aws_route_table.private_route_table.id
}
