############################################
# Create Network ACL and rules
############################################
# Public NACL first!
resource "aws_network_acl" "VPC_ACL_Public" {
  vpc_id = aws_vpc.tna_vpc.id
  subnet_ids = [
    aws_subnet.public_1a.id,aws_subnet.public_1b.id
  ]
  tags = {
    Name = "Public-NACL-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_network_acl_rule" "inbound_http_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 100
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.browse_access
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "inbound_http_8080_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 105
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.browse_access
  from_port = "8080"
  to_port = "8080"
}

resource "aws_network_acl_rule" "inbound_https_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 110
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.browse_access
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "inbound_ssh_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 115
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.browse_access
  from_port = "22"
  to_port = "22"
}

// allow starttls access for SMTP emails from private to SES
resource "aws_network_acl_rule" "inbound_starttls_public" {
  count = length(local.Private-subnet)
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 120+count.index
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = element(local.Private-subnet, count.index)
  from_port = "587"
  to_port = "587"
}

resource "aws_network_acl_rule" "inbound_ephemeral_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 130
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.browse_access
  from_port = "1024"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_http_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 100
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "outbound_https_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 110
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 120
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "1024"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Public.id
  rule_number = 130
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "587"
  to_port = "587"
}

# Private NACL
resource "aws_network_acl" "VPC_ACL_Private" {
  vpc_id = aws_vpc.tna_vpc.id
  subnet_ids = [
    aws_subnet.private_1a.id,aws_subnet.private_1b.id
  ]
  tags = {
    Name = "Private-NACL-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_network_acl_rule" "inbound_http_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 100
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "10.0.0.0/8"
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "inbound_https_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 110
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "10.0.0.0/8"
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "inbound_https_private_from_onprem" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 112
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "172.31.2.0/24"
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "inbound_ephemeral_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 120
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "1024"
  to_port = "65535"
}

# NOTE NACL Egress Rules 200 and 210 are defined in discovery/message-queue. I suggest we reserve the 2xx range for
# rules injected by other modules

resource "aws_network_acl_rule" "outbound_http_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 100
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "outbound_https_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 110
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "443"
  to_port = "443"
}

// Ports 1024-65535 are needed outbound on any network using an ELB as it uses that whole range
// The CIDR block could possibly be restricted to the subnets containing the ELB as the only devices
// the app servers communicate with on ephemeral ports below 32768 will probably be the ELBs

// TODO: fix the cidr_block to use a variable that specifies the public and private subnets
//       This will allow us to keep the more restrictive rule at 130.
resource "aws_network_acl_rule" "outbound_ephemeral_private_to_public" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 120
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "10.128.0.0/16"
  from_port = "1024"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 130
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "587"
  to_port = "587"
}

resource "aws_network_acl_rule" "outbound_ephemeral_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 140
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "32768"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_mongo_private" {
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 145
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "27017"
  to_port = "27019"
}

resource "aws_network_acl_rule" "outbound_mysql_private" {
  count = length(local.Private-db-subnet)
  network_acl_id = aws_network_acl.VPC_ACL_Private.id
  rule_number = 150+count.index
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = element(local.Private-db-subnet, count.index)
  from_port = "3306"
  to_port = "3306"
}

# Private Database subnet NACLs

resource "aws_network_acl" "VPC_ACL_Private_DB" {
  vpc_id = aws_vpc.tna_vpc.id
  subnet_ids = [
    aws_subnet.private_db_1a.id,aws_subnet.private_db_1b.id
  ]
  tags = {
    Name = "Private-DB-NACL-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_network_acl_rule" "inbound_mysql" {
  count = length(local.Private-subnet)
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 100+count.index
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = element(local.Private-subnet, count.index)
  from_port = "3306"
  to_port = "3306"
}

resource "aws_network_acl_rule" "inbound_mysql_TNA" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 110
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.intersite-computers
  from_port = "3306"
  to_port = "3306"
}

resource "aws_network_acl_rule" "inbound_mssql" {
  count = length(local.Private-subnet)
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 120+count.index
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = element(local.Private-subnet, count.index)
  from_port = "4333"
  to_port = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_ssis" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 130
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.ssis_server
  from_port = "4333"
  to_port = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_onprem_lobapp" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 140
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.lobapp_servers
  from_port = "4333"
  to_port = "4333"
}

resource "aws_network_acl_rule" "outbound_ephemeral_DB" {
  count = length(local.Private-subnet)
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 100+count.index
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = element(local.Private-subnet, count.index)
  from_port = "32768"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_http_DB" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 110
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "outbound_https_DB" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 120
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_TNA_DB" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 105
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.intersite-computers
  from_port = "32768"
  to_port = "65535"
}

resource "aws_network_acl_rule" "outbound_ephemeral_ssis" {
  network_acl_id = aws_network_acl.VPC_ACL_Private_DB.id
  rule_number = 130
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = var.ssis_server
  from_port = "32768"
  to_port = "65535"
}


/*
The NACLs are now finished!
*/
