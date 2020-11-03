##############################################
# Security group time!
##############################################

# Outside world inbound web:

resource "aws_security_group" "generic_mgmt"{
  name = "Generic-management-${var.Environment}"
  description = "This is a generic security group to be populated by peering when initiated."
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "Generic-management-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

# From Public to private web servcies

resource "aws_security_group" "private_web_access" {
  name = "Private-web-access-${var.Environment}"
  description = "Allow traffic from public subnet and some outbound"
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "Private-access-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_security_group_rule" "private_http_inbound" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [var.Public-subnet-1a,var.Public-subnet-1b,var.intersite-computers,var.tna_dev_network]

  security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_https_inbound" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [var.Public-subnet-1a,var.Public-subnet-1b,var.intersite-computers,var.tna_dev_network,var.tna_soaapp_network]

  security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_http_outbound" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_https_outbound" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_internal_outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]

  security_group_id = aws_security_group.private_web_access.id
}

resource "aws_security_group_rule" "private_mongo_outbound" {
  type = "egress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_web_access.id
}

# Database security groups
# MysSQL first!
resource "aws_security_group" "private_mysql_access" {
  name = "Private-mysql-access-${var.Environment}"
  description = "Allow MySQL traffic inbound from private web subnet and let some traffic out"
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "Private-MySQL-access-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_security_group_rule" "private_mysql_inbound" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = [var.Private-subnet-1a,var.Private-subnet-1b,var.intersite-computers]

  security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_http_outbound" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_https_outbound" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_mysql_access.id
}

resource "aws_security_group_rule" "private_mysql_internal_outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]

  security_group_id = aws_security_group.private_mysql_access.id
}

# Now MS SQL Server:
resource "aws_security_group" "private_mssql_access" {
  name = "Private-mssql-access-${var.Environment}"
  description = "Allow MS SQL traffic inbound from private web subnet and let some traffic out"
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "Private-MS-SQL-access-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_security_group_rule" "private_mssql_inbound" {
  type = "ingress"
  from_port = 4333
  to_port = 4333
  protocol = "tcp"
  cidr_blocks = [var.Private-subnet-1a,var.Private-subnet-1b,var.intersite-computers,var.ssis_server]

  security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_http_outbound" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_https_outbound" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_mssql_access.id
}

resource "aws_security_group_rule" "private_mssql_internal_outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]

  security_group_id = aws_security_group.private_mssql_access.id
}



# Management stuff

resource "aws_security_group" "mgmt_security_group" {
  name = "Mgmt-access-${var.Environment}"
  description = "Allow management traffic inbound"
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "Private-MGMT-access-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_security_group_rule" "mgmt_ssh_inbound" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_rdp_inbound" {
  type = "ingress"
  from_port = 3389
  to_port = 3389
  protocol = "tcp"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_smb_inbound" {
  type = "ingress"
  from_port = 445
  to_port = 445
  protocol = "tcp"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_winrm_inbound" {
  type = "ingress"
  from_port = 5985
  to_port = 5986
  protocol = "tcp"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "mgmt_SQL_inbound" {
  type = "ingress"
  from_port = 4333
  to_port = 4333
  protocol = "tcp"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}


resource "aws_security_group_rule" "mgmt_access_inbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.intersite-computers]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "priv_mgmt_http" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mgmt_security_group.id
}

resource "aws_security_group_rule" "priv_mgmt_https" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mgmt_security_group.id
}


# Security groups done for now
