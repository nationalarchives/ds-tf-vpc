output "db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.id
}

output "id" {
    value = aws_vpc.vpc.id
}

output "public_subs_ids" {
    value = aws_subnet.public_subs[*].id
}

output "private_subs_ids" {
    value = aws_subnet.private_subs[*].id
}

output "private_db_subs_ids" {
    value = aws_subnet.private_db_subs[*].id
}

output "public_rt" {
    value = aws_route_table.public_rt.id
}

output "private_rt" {
    value = aws_route_table.private_rt.id
}
