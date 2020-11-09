# ------------------------------------------------------------------------------
# NACL and rules for public subnet
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
resource "aws_network_acl" "nacl_public" {
    vpc_id = data.terraform_remote_state.vpc.outputs.id

    subnet_ids = [
        data.terraform_remote_state.vpc.outputs.public_1a.id,
        data.terraform_remote_state.vpc.outputs.public_1b.id]

    tags = {
        Name        = "public-nacl-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "inbound_http_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 100
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "inbound_http_8080_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 105
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "8080"
    to_port        = "8080"
}

resource "aws_network_acl_rule" "inbound_https_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 110
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "inbound_ssh_public" {
    network_acl_id = aws_network_acl.nacl_public.id
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
    count          = length(data.terraform_remote_state.vpc.outputs.private_subnets)
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 120+count.index
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
    from_port      = "587"
    to_port        = "587"
}

resource "aws_network_acl_rule" "inbound_ephemeral_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 130
    egress         = false
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = var.browse_access
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_http_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 100
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "80"
    to_port        = "80"
}

resource "aws_network_acl_rule" "outbound_https_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 110
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "443"
    to_port        = "443"
}

resource "aws_network_acl_rule" "outbound_ephemeral_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 120
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "1024"
    to_port        = "65535"
}

resource "aws_network_acl_rule" "outbound_starttls_public" {
    network_acl_id = aws_network_acl.nacl_public.id
    rule_number    = 130
    egress         = true
    protocol       = "tcp"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = "587"
    to_port        = "587"
}