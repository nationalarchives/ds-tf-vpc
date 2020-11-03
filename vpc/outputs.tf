output "db_subnet_group" {
  value = "${aws_db_subnet_group.db_subnet_group.id}"
}

output "vpc" {
  value = "${aws_vpc.tna_vpc.id}"
}

output "vpc_cidr"{
  description = "Cidr block of this VPC"
  value = "${aws_vpc.tna_vpc.cidr_block}"
}

output "publicsubnets" {
  value = ["${aws_subnet.public_1a.id}","${aws_subnet.public_1b.id}"]
}

output "privatesubnets" {
  value = ["${aws_subnet.private_1a.id}","${aws_subnet.private_1b.id}"]
}

output "mysql_security_groups" {
  value = ["${aws_security_group.private_mysql_access.id}","${aws_security_group.mgmt_security_group.id}"]
}

output "mssql_security_groups" {
  value = ["${aws_security_group.private_mssql_access.id}","${aws_security_group.mgmt_security_group.id}"]
}

output "public_route_table" {
  description = "Public route table for peering stuff"
  value = "${aws_route_table.public_route_table.id}"
}

output "private_route_table" {
  description = "Private route table for peering stuff"
  value = "${aws_route_table.private_route_table.id}"
}

output "public_NACL"{
  description = "NACL ID for peering stuff"
  value = "${aws_network_acl.VPC_ACL_Public.id}"
}

output "private_NACL"{
  description = "NACL ID for peering stuff"
  value = "${aws_network_acl.VPC_ACL_Private.id}"
}

output "private_db_NACL"{
  description = "NACL ID for peering stuff"
  value = "${aws_network_acl.VPC_ACL_Private_DB.id}"
}

output "management_sg" {
  description = "Management security group to be populated by peering"
  value = "${aws_security_group.generic_mgmt.id}"
}

output "private_sg" {
  value = "${aws_security_group.private_web_access.id}"
}
