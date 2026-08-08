terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  az_count     = length(var.azs)
  has_public   = length(var.public_subnet_cidrs) > 0
  has_private  = length(var.private_subnet_cidrs) > 0
  nat_gw_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.az_count) : 0
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_internet_gateway" "this" {
  count  = local.has_public ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index % local.az_count]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${count.index}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % local.az_count]

  tags = merge(var.tags, {
    Name = "${var.name}-private-${count.index}"
    Tier = "private"
  })
}

resource "aws_route_table" "public" {
  count  = local.has_public ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-public"
  })
}

resource "aws_route" "public_internet" {
  count                  = local.has_public ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  count  = local.nat_gw_count
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-${count.index}"
  })
}

resource "aws_nat_gateway" "this" {
  count         = local.nat_gw_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    Name = "${var.name}-nat-${count.index}"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count  = local.has_private ? local.az_count : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-private-${count.index}"
  })
}

resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway ? local.az_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index % local.az_count].id
}
