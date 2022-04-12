resource "aws_vpc" "this" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "my_gw"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnets)

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = format("NAT for -%s", element(var.azs, count.index))
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = format("public subnet in -%s", element(var.azs, count.index))
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = format("private subnet in -%s", element(var.azs, count.index))
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name = format("private route table in -%s", element(var.azs, count.index))
  }
}

resource "aws_route_table_association" "custom-rtb-public-subnet" {
  count = length(var.public_subnets)

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.*.id[count.index]
}

resource "aws_route_table_association" "custom-rtb-private-subnet" {
  count = length(var.private_subnets)

  route_table_id = aws_route_table.private.*.id[count.index]
  subnet_id      = aws_subnet.private.*.id[count.index]
}
