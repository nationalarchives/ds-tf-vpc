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
