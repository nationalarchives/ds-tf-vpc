# ------------------------------------------------------------------------------
# NACL and rules for private subnet
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_nacl_private" {
    vpc_id     = var.vpc_id
    subnet_ids = var.private_subnet_ids

    tags = {
        Name        = "private-nacl-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "private_nacl_rule" {
    count = length(var.private_nacls)

    network_acl_id = aws_network_acl.vpc_nacl_private.id
    rule_number    = var.private_nacls[count.index]["rule_number"]
    egress         = var.private_nacls[count.index]["egress"]
    protocol       = var.private_nacls[count.index]["protocol"]
    rule_action    = var.private_nacls[count.index]["rule_action"]
    cidr_block     = var.private_nacls[count.index]["cidr_block"]
    from_port      = var.private_nacls[count.index]["from_port"]
    to_port        = var.private_nacls[count.index]["to_port"]
}
