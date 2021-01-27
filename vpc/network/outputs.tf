output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "vpc_cidr" {
    value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
    value= { for subnet in aws_subnet.public_subs : subnet.tags.Name => subnet.id }
}

output "private_subnet_ids" {
    value= { for subnet in aws_subnet.private_subs : subnet.tags.Name => subnet.id }
}

output "private_db_subnet_ids" {
    value= { for subnet in aws_subnet.private_db_subs : subnet.tags.Name => subnet.id }
}

output "public_rt" {
    value = aws_route_table.public_rt.id
}

output "private_rt" {
    value = aws_route_table.private_rt.id
}
