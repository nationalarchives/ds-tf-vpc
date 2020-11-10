# ------------------------------------------------------------------------------
# security groups
# ------------------------------------------------------------------------------
# outside world inbound web:

resource "aws_security_group" "generic_mgmt" {
    name        = "generic-management-${var.environment}"
    description = "generic security group to be populated by peering when initiated."
    vpc_id      = var.vpc_id

    tags = {
        Name        = "Generic-management-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
    }
}

# ------------------------------------------------------------------------------
# public to private web servcies
# ------------------------------------------------------------------------------
resource "aws_security_group" "private_web_access" {
    name        = "private-web-access-${var.environment}"
    description = "Allow traffic from public subnet and some outbound"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "private-access-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_security_group_rule" "private_http_inbound" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(var.public_cidrs, [
        var.intersite_vpc,
        var.kew_developer_network])

    security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_https_inbound" {
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.public_cidrs, [
        var.intersite_vpc,
        var.kew_developer_network,
        var.kew_app_network])

    security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_http_outbound" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_https_outbound" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_internal_outbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
        var.vpc_cidr]

    security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_mongo_outbound" {
    type        = "egress"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_web_access.id
}

# ------------------------------------------------------------------------------
# database security groups
# ------------------------------------------------------------------------------
# MysSQL
resource "aws_security_group" "private_mysql_access" {
    name        = "private-mysql-access-${var.environment}"
    description = "Allow MySQL traffic inbound from private web subnet and let some traffic out"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "private-MySQL-access-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_security_group_rule" "private_mysql_inbound" {
    type        = "ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(var.private_cidrs, [
        var.intersite_vpc])

    security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_http_outbound" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_https_outbound" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_internal_outbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
        var.vpc_cidr]

    security_group_id = aws_security_group.private_mysql_access.id
}

# ------------------------------------------------------------------------------
# MS-SQL server:
# ------------------------------------------------------------------------------
resource "aws_security_group" "private_mssql_access" {
    name        = "private-mssql-access-${var.environment}"
    description = "Allow MS SQL traffic inbound from private web subnet and let some traffic out"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "private-MS-SQL-access-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_security_group_rule" "private_mssql_inbound" {
    type        = "ingress"
    from_port   = 4333
    to_port     = 4333
    protocol    = "tcp"
    cidr_blocks = concat(var.private_cidrs, [
        var.intersite_vpc,
        var.kew_ssis_server])

    security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_http_outbound" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_https_outbound" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_internal_outbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
        var.vpc_cidr]

    security_group_id = aws_security_group.private_mssql_access.id
}

# ------------------------------------------------------------------------------
# management stuff
# ------------------------------------------------------------------------------
resource "aws_security_group" "mgmt_security_group" {
    name        = "mgmt-access-${var.environment}"
    description = "management traffic inbound"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "Private-MGMT-access-${var.environment}"
        Environment = var.environment
        Terraform   = "True"
    }
}

resource "aws_security_group_rule" "mgmt_ssh_inbound" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_rdp_inbound" {
    type        = "ingress"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_smb_inbound" {
    type        = "ingress"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_winrm_inbound" {
    type        = "ingress"
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_SQL_inbound" {
    type        = "ingress"
    from_port   = 4333
    to_port     = 4333
    protocol    = "tcp"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_access_inbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
        var.intersite_vpc]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "priv_mgmt_http" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "priv_mgmt_https" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
        var.everyone]

    security_group_id = aws_security_group.mgmt_security_group.id
}
