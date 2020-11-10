output "mysql_sg" {
    value = [
        aws_security_group.private_mysql_access.id,
        aws_security_group.mgmt_security_group.id]
}

output "mssql_sg" {
    value = [
        aws_security_group.private_mssql_access.id,
        aws_security_group.mgmt_security_group.id]
}

output "public_nacl" {
    description = "nacl id for peering stuff"
    value       = aws_network_acl.vpc_nacl_public.id
}

output "private_nacl" {
    description = "nacl id for peering stuff"
    value       = aws_network_acl.vpc_nacl_private.id
}

output "private_db_nacl" {
    description = "nacl id for peering stuff"
    value       = aws_network_acl.vpc_nacl_private_db.id
}

output "management_sg" {
    description = "management security group to be populated by peering"
    value       = aws_security_group.generic_mgmt.id
}

output "private_sg" {
    value = aws_security_group.private_web_access.id
}
