# Primary VPC resources


resource "aws_vpc" "tna_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.Environment}_VPC"
    Environment = var.Environment
    Terraform = "True"
  }
}

# Create a Cloudwatch Log Group for VPC flow logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "${title(var.Environment)}_VPC_Flowlog"

  tags = {
    Environment = var.Environment
    Terraform   = "True"
    Owner       = "auto-modernise"
    CreatedBy   = "steven.hirschorn@nationalarchives.gov.uk"
  }
}

# Create an IAM role granting access to flow logs
resource "aws_iam_role" "flow_logs_role" {
  name = "flow_logs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Environment = var.Environment
    Terraform   = "True"
    Owner       = "auto-modernise"
    CreatedBy   = "steven.hirschorn@nationalarchives.gov.uk"
  }
}

# Assign a policy to the role
resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "${var.Environment}_flow_logs_policy"
  role = aws_iam_role.flow_logs_role.id

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

# Enable flow logs for the VPC
resource "aws_flow_log" "flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.tna_vpc.id
}

# Internet gateway for access outbound
#
resource "aws_internet_gateway" "tna-IGW" {
  vpc_id = aws_vpc.tna_vpc.id

  tags = {
    Name = "${var.Environment}-IGW"
    Environment = var.Environment
    Terraform = "True"
  }
}
# End Internet Gateway


# EIP and NAT instance for NATting the private subnet when accessing internet.
#
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Environment = var.Environment
    Terraform = "True"
    Description = "EIP for NATting the private subnet when accessing internet"
  }
}

resource "aws_nat_gateway" "Nat_Gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_1a.id

}
# End EIP and NAT instances

############################################
# Create the subnets using CIDR blocks from variables
############################################
# Create the public subnets!

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Public-subnet-1a
  map_public_ip_on_launch = true
  availability_zone = "${var.vpc_region}a"

  tags = {
    Name = "Public-subnet-1a-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Public-subnet-1b
  map_public_ip_on_launch = true
  availability_zone = "${var.vpc_region}b"

  tags = {
    Name = "Public-subnet-1b-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}


# Create the private subnets!

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Private-subnet-1a
  map_public_ip_on_launch = false
  availability_zone = "${var.vpc_region}a"

  tags = {
    Name = "Private-subnet-1a-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Private-subnet-1b
  map_public_ip_on_launch = false
  availability_zone = "${var.vpc_region}b"

  tags = {
    Name = "Private-subnet-1b-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

# Create the DB subnets!

resource "aws_subnet" "private_db_1a" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Private-db-subnet-1a
  map_public_ip_on_launch = false
  availability_zone = "${var.vpc_region}a"

  tags = {
    Name = "Private-db-subnet-1a-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

resource "aws_subnet" "private_db_1b" {
  vpc_id = aws_vpc.tna_vpc.id
  cidr_block = var.Private-db-subnet-1b
  map_public_ip_on_launch = false
  availability_zone = "${var.vpc_region}b"

  tags = {
    Name = "Private-db-subnet-1b-${var.Environment}"
    Environment = var.Environment
    Terraform = "True"
  }
}

# Add DB Subnet Group for launching RDS instances

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "tna-db_subnet_group_${var.Environment}"
  subnet_ids = [aws_subnet.private_db_1a.id,aws_subnet.private_db_1b.id]

  tags = {
    Name = "${var.Environment}- DB Subnet Group"
    Terraform = "True"
  }
}


############################################
# Subnets are finished
############################################
