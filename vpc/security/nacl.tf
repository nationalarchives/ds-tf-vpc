# ------------------------------------------------------------------------------
# NACL and rules
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
# public NACL
resource "aws_network_acl" "vpc_acl_public" {
    vpc_id = aws_vpc.tna_vpc.id

    subnet_ids = [
        aws_subnet.public_1a.id,
        aws_subnet.public_1b.id]
    
    tags = {
        Name        = "public-nacl-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_http_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 100
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "inbound_http_8080_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 105
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "8080"
    to_port        = "8080"
}

resource "aws_network_acl_rule" "inbound_https_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_ssh_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 115
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "22"
    to_port        = "22"
}

// allow starttls access for SMTP emails from private to SES
resource "aws_network_acl_rule" "inbound_starttls_public" {
    count          = length(local.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 120+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(local.private_subnets, count.index)
    from_port      = "587"
    to_port        = "587"
}

resource "aws_network_acl_rule" "inbound_ephemeral_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 130
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_http_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 100
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_public" {
    network_acl_id = aws_network_acl.vpc_acl_public.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "587"
    to_port        = "587"
}

# private NACL
resource "aws_network_acl" "vpc_acl_private" {
    vpc_id     = aws_vpc.tna_vpc.id

    subnet_ids = [
        aws_subnet.private_1a.id,
        aws_subnet.private_1b.id]

    tags       = {
        Name        = "private-nacl-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_http_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 100
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "10.0.0.0/8"
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "inbound_https_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "10.0.0.0/8"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_https_private_from_onprem" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 112
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "172.31.2.0/24"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_ephemeral_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 120
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "1024"
    to_port        = "65535"
}

# outbound rules
resource "aws_network_acl_rule" "outbound_http_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 100
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_private_to_public" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "10.128.0.0/16"
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "587"
    to_port        = "587"
}

resource "aws_network_acl_rule" "outbound_ephemeral_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 140
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_mongo_private" {
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 145
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "27017"
    to_port        = "27019"
}

resource "aws_network_acl_rule" "outbound_mysql_private" {
    count          = length(local.private_db_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private.id
    rule_number    = 150+count.index
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(local.private_db_subnets, count.index)
    from_port      = "3306"
    to_port        = "3306"
}

# Private Database subnet NACLs
resource "aws_network_acl" "vpc_acl_private_DB" {
    vpc_id     = aws_vpc.tna_vpc.id
    subnet_ids = [
        aws_subnet.private_db_1a.id,
        aws_subnet.private_db_1b.id
    ]
    tags       = {
        Name        = "Private-DB-NACL-${var.environment}"
        environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_mysql" {
    count          = length(local.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 100+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(local.private_subnets, count.index)
    from_port      = "3306"
    to_port        = "3306"
}

resource "aws_network_acl_rule" "inbound_mysql_TNA" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.intersite_computers
    from_port      = "3306"
    to_port        = "3306"
}

resource "aws_network_acl_rule" "inbound_mssql" {
    count          = length(local.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 120+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(local.private_subnets, count.index)
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_ssis" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 130
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.ssis_server
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_onprem_lobapp" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 140
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.lobapp_servers
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "outbound_ephemeral_DB" {
    count          = length(local.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 100+count.index
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(local.private_subnets, count.index)
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_http_DB" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_DB" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_TNA_DB" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 105
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.intersite_computers
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_ephemeral_ssis" {
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.ssis_server
    from_port      = "32768"
    to_port        = "65535"
}


/*
The NACLs are now finished!
*/
