locals {
  nat_gateway_count = "${var.single_nat_gateway == "true" ? 1 : var.one_nat_gateway_per_az == "true" ? length(var.azs) : length(var.vpc_private_subnet_cidr_block)}"
}

### VPC 

resource "aws_vpc" "vpc_new" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
  enable_dns_support   = "${var.vpc_enable_dns_support}"

  tags = "${merge(var.tags, var.vpc_tags)}"
}

### SUBNETS

resource "aws_subnet" "public" {
  count = "${length(var.vpc_public_subnet_cidr_block)}"

  vpc_id                  = "${aws_vpc.vpc_new.id}"
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.vpc_public_subnet_cidr_block, count.index)}"
  map_public_ip_on_launch = "${var.vpc_subnet_map_public_ip_on_launch}"

  tags = "${merge(var.tags, var.subnet_public_tags)}"
}

resource "aws_subnet" "private" {
  count = "${length(var.vpc_private_subnet_cidr_block)}"

  vpc_id                  = "${aws_vpc.vpc_new.id}"
  cidr_block              = "${element(var.vpc_private_subnet_cidr_block, count.index)}"
  map_public_ip_on_launch = "${var.vpc_subnet_map_public_ip_on_launch}"

  tags = "${merge(var.tags, var.subnet_private_tags)}"
}

### ELASTIC IPs

resource "aws_eip" "eip" {
  count = "${local.nat_gateway_count}"
}

### NAT GATEWAY

resource "aws_nat_gateway" "nat_gw" {
  count         = "${length(var.vpc_public_subnet_cidr_block) * (local.nat_gateway_count) > 0 ? local.nat_gateway_count : 0}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"

  tags = "${merge(var.tags, var.nat_gateway_tags)}"
}

resource "aws_internet_gateway" "internet_gw" {
  count = "${length(var.vpc_public_subnet_cidr_block) * (var.internet_gateway == "true" ? 1 : 0) > 0 ? 1 : 0 }"

  vpc_id = "${aws_vpc.vpc_new.id}"

  tags = "${merge(var.tags, var.internet_gateway_tags)}"
}

resource "aws_route_table" "public" {
  count = "${length(var.vpc_public_subnet_cidr_block) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.vpc_new.id}"

  tags = "${merge(var.tags, var.public_route_table_tags)}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${length(var.vpc_public_subnet_cidr_block) * (var.internet_gateway == "true" ? 1 : 0)  > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.0.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gw.0.id}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private" {
  count = "${(local.nat_gateway_count) * length(var.vpc_private_subnet_cidr_block) > 0 ? local.nat_gateway_count : 0}"

  vpc_id = "${aws_vpc.vpc_new.id}"

  tags = "${merge(var.tags, var.private_route_table_tags)}"
}

resource "aws_route" "private_nat_gateway" {
  count = "${length(var.vpc_private_subnet_cidr_block) > 0 ? local.nat_gateway_count : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gw.*.id, count.index)}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.vpc_public_subnet_cidr_block) > 0 ? length(var.vpc_public_subnet_cidr_block) : 0}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.vpc_private_subnet_cidr_block) > 0 ? length(var.vpc_private_subnet_cidr_block) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
