resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = merge(
        var.tags,
        {
            Name = "${var.environment}-${var.project}-vpc"
        }
    )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-nat-eip-${count.index + 1}"
    }
  )
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-public-subnet-${count.index + 1}"
        Tier = "Public"
    }
  )
}

resource "aws_subnet" "frontend" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.frontend_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-frontend-subnet-${count.index + 1}"
        Tier = "Frontend "
    }
  )
}

resource "aws_subnet" "Backend" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.Backend_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-Backend-subnet-${count.index + 1}"
        Tier = "Backend"
    }
  )
}

resource "aws_subnet" "Database" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-database-subnet-${count.index + 1}"
        Tier = "Database"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-nat-gateway-${count.index + 1}"
    }
  )

  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-public-route-table"
        Tier = "Public"
    }
  )
}

resource "aws_route" "public-route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table" "frontend" {
  count = var.enable_nat_gateway ? length(var.availability_zones) : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-frontend-route-table-${count.index}"
        Tier = "Frontend"
    }
  )
}

resource "aws_route" "frontend-route" {
    count = var.enable_nat_gateway ? length(var.availability_zones) : 0
    route_table_id = aws_route_table.frontend[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "frontend" {
    count = length(var.availability_zones) 
    route_table_id =  var.enable_nat_gateway ? aws_route_table.frontend[count.index].id : null
    subnet_id = aws_subnet.frontend[count.index].id
}


resource "aws_route_table" "backend" {
  count = var.enable_nat_gateway ? length(var.availability_zones) : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-backend-route-table-${count.index}"
        Tier = "Backend"
    }
  )
}

resource "aws_route" "backend-route" {
    count = var.enable_nat_gateway ? length(var.availability_zones) : 0
    route_table_id = aws_route_table.backend[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "backend" {
    count = length(var.availability_zones) 
    route_table_id =  var.enable_nat_gateway ? aws_route_table.backend[count.index].id : null
    subnet_id = aws_subnet.Backend[count.index].id
}

resource "aws_route_table" "database" {
  count = var.enable_nat_gateway ? length(var.availability_zones) : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-database-route-table-${count.index}"
        Tier = "Database"
    }
  )
}

resource "aws_route_table_association" "database" {
    count = length(var.availability_zones) 
    route_table_id =  var.enable_nat_gateway ? aws_route_table.database[count.index].id : null
    subnet_id = aws_subnet.Database[count.index].id
}