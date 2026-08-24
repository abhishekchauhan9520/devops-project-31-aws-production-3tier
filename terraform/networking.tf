resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" { vpc_id = aws_vpc.main.id }

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = { Name = "p31-public-${count.index + 1}" }
}

resource "aws_subnet" "app" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = { Name = "p31-app-${count.index + 1}" }
}

resource "aws_subnet" "db" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = { Name = "p31-db-${count.index + 1}" }
}

resource "aws_route_table" "public" { vpc_id = aws_vpc.main.id route { cidr_block = "0.0.0.0/0" gateway_id = aws_internet_gateway.main.id } }
resource "aws_route_table_association" "public" { count = 2 subnet_id = aws_subnet.public[count.index].id route_table_id = aws_route_table.public.id }

resource "aws_eip" "nat" { count = 2 domain = "vpc" }
resource "aws_nat_gateway" "nat" { count = 2 allocation_id = aws_eip.nat[count.index].id subnet_id = aws_subnet.public[count.index].id depends_on = [aws_internet_gateway.main] }

resource "aws_route_table" "app" {
  count  = 2
  vpc_id = aws_vpc.main.id
  route { cidr_block = "0.0.0.0/0" nat_gateway_id = aws_nat_gateway.nat[count.index].id }
}
resource "aws_route_table_association" "app" { count = 2 subnet_id = aws_subnet.app[count.index].id route_table_id = aws_route_table.app[count.index].id }

resource "aws_route_table" "db" { vpc_id = aws_vpc.main.id }
resource "aws_route_table_association" "db" { count = 2 subnet_id = aws_subnet.db[count.index].id route_table_id = aws_route_table.db.id }
