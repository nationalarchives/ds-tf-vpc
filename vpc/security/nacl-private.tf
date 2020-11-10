# ------------------------------------------------------------------------------
# NACL and rules for private subnet
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_nacl_private" {
    vpc_id     = var.vpc_id

    tags = {
        Name        = "private-nacl-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_http_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 100
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.http_vpc
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "inbound_https_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.http_vpc
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_https_private_from_onprem" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 112
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.kew_app_network
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_ephemeral_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 120
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "1024"
    to_port        = "65535"
}

# outbound rules
resource "aws_network_acl_rule" "outbound_http_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 100
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_private_to_public" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.priv_to_pub
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "587"
    to_port        = "587"
}

resource "aws_network_acl_rule" "outbound_ephemeral_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 140
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "32768"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_mongo_private" {
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 145
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.everyone
    from_port      = "27017"
    to_port        = "27019"
}

resource "aws_network_acl_rule" "outbound_mysql_private" {
    count          = length(var.private_db_cidrs)
    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = 150+count.index
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(var.private_db_cidrs, count.index)
    from_port      = "3306"
    to_port        = "3306"
}
