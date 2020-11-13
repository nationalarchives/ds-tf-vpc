output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    value = concat([], aws_subnet.public_subs[*].id)
}

output "private_subnet_ids" {
    value = concat([], aws_subnet.private_subs[*].id)
}

output "private_db_subnet_ids" {
    value = concat([], aws_subnet.private_db_subs[*].id)
}

output "public_rt" {
    value = aws_route_table.public_rt.id
}

output "private_rt" {
    value = aws_route_table.private_rt.id
}
