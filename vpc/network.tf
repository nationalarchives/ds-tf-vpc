# ------------------------------------------------------------------------------
# building vpc and all required subnets
# ------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.Environment}_VPC"
    Environment = var.Environment
    Terraform = "True"
  }
}
