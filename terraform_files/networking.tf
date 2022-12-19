# prod - VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "prod_vpc"
  }
}

################################################################################

# Public Subnets for bastions

resource "aws_subnet" "prod-subnet-public1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod1_public_subnet_cidr_block
  availability_zone       = var.prod1_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "prod-subnet-public1"
  }
}

resource "aws_subnet" "prod-subnet-public2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod2_public_subnet_cidr_block
  availability_zone       = var.prod2_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "prod-subnet-public2"
  }
}

################################################################################

# Private Subnets have to be allowed to automatically map public IP addresses for worker nodes
resource "aws_subnet" "prod-subnet-private1-worker" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod1_subnet_cidr_block
  availability_zone       = var.prod1_subnet_az
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "prod-subnet-private1-worker"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "prod-subnet-private2-worker" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod2_subnet_cidr_block
  availability_zone       = var.prod2_subnet_az
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "prod-subnet-private2-worker"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}
################################################################################

# Private Subnets for DB
resource "aws_subnet" "prod-subnet-private1-db" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod1_db_subnet_cidr_block
  availability_zone       = var.prod1_subnet_az
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-subnet-private1-db"
  }
}

resource "aws_subnet" "prod-subnet-private2-db" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.prod2_db_subnet_cidr_block
  availability_zone       = var.prod2_subnet_az
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-subnet-private2-db"
  }
}

################################################################################

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

################################################################################
# Create EIP for NAT Gateway 1, 2
resource "aws_eip" "eip-ngw-public1" {
  vpc = true
}
resource "aws_eip" "eip-ngw-public2" {
  vpc = true
}

resource "aws_nat_gateway" "ngw-public1" {
  allocation_id = aws_eip.eip-ngw-public1.id
  subnet_id = aws_subnet.prod-subnet-public1.id
  tags = {
    "Name" = "ngw-public1"
  }
}
resource "aws_nat_gateway" "ngw-public2" {
  allocation_id = aws_eip.eip-ngw-public2.id
  subnet_id = aws_subnet.prod-subnet-public2.id
  tags = {
    "Name" = "ngw-public2"
  }
}

################################################################################

# Route Table for public subnet 1 and public subnet 2
resource "aws_route_table" "prod-rtb-public" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }

  tags = {
    Name = "prod-rtb-public"
  }
}
# Route Table for prod-subnet-prvate1-worker
resource "aws_route_table" "prod-rtb-prvate1-worker" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-public1.id
  }


  tags = {
    Name = "prod-rtb-prvate1-worker"
  }
}
# Route Table for prod-subnet-prvate2-worker
resource "aws_route_table" "prod-rtb-prvate2-worker" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-public2.id
  }


  tags = {
    Name = "prod-rtb-prvate2-worker"
  }
}
# Route Table for prod-subnet-prvate1-db and prod-subnet-prvate2-db
resource "aws_route_table" "prod-rtb-prvate-db" {
  vpc_id = aws_vpc.prod-vpc.id


  tags = {
    Name = "prod-rtb-prvate-db"
  }
}





################################################################################

resource "aws_route_table_association" "prod1-rtb-public1" {
  subnet_id = aws_subnet.prod-subnet-public1.id
  route_table_id = aws_route_table.prod-rtb-public.id
}
resource "aws_route_table_association" "prod2-rtb-public2" {
  subnet_id = aws_subnet.prod-subnet-public2.id
  route_table_id = aws_route_table.prod-rtb-public.id
}

resource "aws_route_table_association" "prod1-sub-to-prod-rt" {
  subnet_id      = aws_subnet.prod-subnet-private1-worker.id
  route_table_id = aws_route_table.prod-rtb-prvate1-worker.id
}

resource "aws_route_table_association" "prod2-sub-to-prod-rt" {
  subnet_id      = aws_subnet.prod-subnet-private2-worker.id
  route_table_id = aws_route_table.prod-rtb-prvate2-worker.id
}

resource "aws_route_table_association" "prod-subnet-private1-db" {
  subnet_id      = aws_subnet.prod-subnet-private1-db.id
  route_table_id = aws_route_table.prod-rtb-prvate-db.id
}
resource "aws_route_table_association" "prod-subnet-private2-db" {
  subnet_id      = aws_subnet.prod-subnet-private2-db.id
  route_table_id = aws_route_table.prod-rtb-prvate-db.id
}
