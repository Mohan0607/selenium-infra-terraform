locals {
  vpc_name = join("-", [var.resource_name_prefix, "vpc"])
}

# Vpc

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.main]

}

resource "aws_eip" "nat_gw" {
  vpc = true
}
# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  count             = length(var.public_subnets_cidr_list)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.public_subnets_cidr_list[count.index]

  tags = {
    Name = join("-", [var.resource_name_prefix, "public", data.aws_availability_zones.available.names[count.index]])
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "bastion_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private with Internet access
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false

  count             = length(var.private_subnets_cidr_list)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.private_subnets_cidr_list[count.index]
  tags = {
    Name = join("-", [var.resource_name_prefix, "private", data.aws_availability_zones.available.names[count.index]])
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


}
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}
resource "aws_route_table_association" "private" {
  count     = length(aws_subnet.private[*].id)
  subnet_id = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.private.id
}

