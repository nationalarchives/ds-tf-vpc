# ------------------------------------------------------------------------------
# NACL and rules for public subnet
# ------------------------------------------------------------------------------
resource "aws_network_acl" "vpc_nacl_public" {
    vpc_id     = var.vpc_id
    subnet_ids = var.public_subnet_ids

    tags = {
        Name        = "public-nacl-${var.environment}"
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_network_acl_rule" "public_nacl_rule" {
    count = length(var.public_nacls)

    network_acl_id = aws_network_acl.vpc_nacl_public.id
    rule_number    = var.public_nacls[count.index]["rule_number"]
    egress         = var.public_nacls[count.index]["egress"]
    protocol       = var.public_nacls[count.index]["protocol"]
    rule_action    = var.public_nacls[count.index]["rule_action"]
    cidr_block     = var.public_nacls[count.index]["cidr_block"]
    from_port      = var.public_nacls[count.index]["from_port"]
    to_port        = var.public_nacls[count.index]["to_port"]
}
