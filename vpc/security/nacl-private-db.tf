# ------------------------------------------------------------------------------
# NACL and rules for private DB subnet
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_acl_private_DB" {
    vpc_id     = data.terraform_remote_state.vpc.outputs.id
    subnet_ids = [
        data.terraform_remote_state.vpc.outputs.private_db_1a.id,
        data.terraform_remote_state.vpc.outputs.private_db_1b.id
    ]
    tags       = {
        Name        = "Private-DB-NACL-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_mysql" {
    count          = length(data.terraform_remote_state.vpc.outputs.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 100+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
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
    count          = length(data.terraform_remote_state.vpc.outputs.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 120+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
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
    count          = length(data.terraform_remote_state.vpc.outputs.private_subnets)
    network_acl_id = aws_network_acl.vpc_acl_private_DB.id
    rule_number    = 100+count.index
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
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
