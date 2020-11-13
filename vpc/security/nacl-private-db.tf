# ------------------------------------------------------------------------------
# NACL and rules for private DB subnet
#
# engress rule range 2xx is reserved for other modules to push required rules
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_nacl_private_db" {
    vpc_id     = var.vpc_id
    subnet_ids = var.private_db_subnet_ids

    tags = {
        Name        = "private-db-nacl-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "true"
    }
}

resource "aws_network_acl_rule" "public_db_nacl_rule" {
    count = length(var.private_db_nacls)

    network_acl_id = aws_network_acl.vpc_nacl_private_db.id
    rule_number    = var.private_db_nacls[count.index]["rule_number"]
    egress         = var.private_db_nacls[count.index]["egress"]
    protocol       = var.private_db_nacls[count.index]["protocol"]
    rule_action    = var.private_db_nacls[count.index]["rule_action"]
    cidr_block     = var.private_db_nacls[count.index]["cidr_block"]
    from_port      = var.private_db_nacls[count.index]["from_port"]
    to_port        = var.private_db_nacls[count.index]["to_port"]
}
