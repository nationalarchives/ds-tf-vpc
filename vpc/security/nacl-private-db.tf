# ------------------------------------------------------------------------------
# NACL and rules for private DB subnet
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_nacl_private_db" {
    vpc_id     = var.vpc_id

    subnet_ids = var.private_db_subnet_ids

    tags = {
        Name        = "Private-DB-NACL-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_mysql" {
    count          = length(var.private_cidrs)
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 100+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(var.private_cidrs, count.index)
    from_port      = "3306"
    to_port        = "3306"
}

resource "aws_network_acl_rule" "inbound_mysql_tna" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.intersite_vpc
    from_port      = "3306"
    to_port        = "3306"
}

resource "aws_network_acl_rule" "inbound_mssql" {
    count          = length(var.private_cidrs)
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 120+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(var.private_cidrs, count.index)
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_ssis" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 130
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.kew_ssis_server
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "inbound_mssql_from_onprem_lobapp" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 140
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.kew_lobapp_network
    from_port      = "4333"
    to_port        = "4333"
}

resource "aws_network_acl_rule" "outbound_ephemeral_db" {
    count          = length(var.private_cidrs)
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 100+count.index
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(var.private_cidrs, count.index)
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_http_db" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_db" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_tna_db" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 105
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.intersite_vpc
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_ephemeral_ssis" {
    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.kew_ssis_server
    from_port      = "32768"
    to_port        = "65535"
}
