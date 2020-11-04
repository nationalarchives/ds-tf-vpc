##############################
# Creating the route tables and routes
##############################
# Public first
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.tna_vpc.id}"
  tags = {
    Name = "Public-Route-Table-${var.Environment}"
    Environment = "${var.Environment}"
    Terraform = "True"
  }
}

resource "aws_route" "Public_route_internet"{
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.tna-IGW.id}"
}

# Private now

resource "aws_route_table" "private_route_table"{
  vpc_id = "${aws_vpc.tna_vpc.id}"

  tags = {
    Name = "Private-Route-Table-${var.Environment}"
    Environment = "${var.Environment}"
    Terraform = "True"
  }
}

resource "aws_route" "Private_route_internet"{
  route_table_id = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.Nat_Gateway.id}"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_1b" {
  subnet_id = "${aws_subnet.public_1b.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_1a" {
  subnet_id = "${aws_subnet.private_1a.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_1b" {
  subnet_id = "${aws_subnet.private_1b.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_db_1a" {
  subnet_id = "${aws_subnet.private_db_1a.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_db_1b" {
  subnet_id = "${aws_subnet.private_db_1b.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
