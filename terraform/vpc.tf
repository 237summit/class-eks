# VPC 생성
resource "aws_vpc" "weplat-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "weplat-vpc"
  }
}

# IGW 생성
resource "aws_internet_gateway" "weplat-igw" {
  vpc_id = resource.aws_vpc.weplat-vpc.id
  tags = {
    Name = "weplat-igw"
  }
}

# EIP 생성
resource "aws_eip" "weplat-bastion-eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name = "weplat-bastion-eip"
  }
}

resource "aws_eip" "weplat-nat-eip" {
  vpc = true

  tags = {
    Name = "weplat-nat-eip"
  }
}

# NAT 생성
resource "aws_nat_gateway" "weplat-nat" {
  allocation_id = aws_eip.weplat-nat-eip.id
  subnet_id     = aws_subnet.pub_sub_c.id

  tags = {
    Name = "weplat-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.weplat-igw]
}


# Public rtb
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.weplat-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.weplat-igw.id
  }

  tags = {
    Name = "weplat-pub-rt"
  }
}

# Private rtb
resource "aws_route_table" "pri_rt_a" {
  vpc_id = aws_vpc.weplat-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.weplat-nat.id
  }

  tags = {
    Name = "weplat-pri-rt-2a"
  }
  depends_on = [aws_nat_gateway.weplat-nat]
}

resource "aws_route_table" "pri_rt_c" {
  vpc_id = aws_vpc.weplat-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.weplat-nat.id
  }

  tags = {
    Name = "weplat-pri-rt-2c"
  }
  depends_on = [aws_nat_gateway.weplat-nat]
}

# rtb association
## public subnet
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_sub_a.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_sub_c.id
  route_table_id = aws_route_table.pub_rt.id
}

## eks-mgnt Subnet(private)
resource "aws_route_table_association" "mgnt_sub_a" {
  subnet_id      = aws_subnet.mgnt_sub_a.id
  route_table_id = aws_route_table.pri_rt_a.id
}

resource "aws_route_table_association" "mgnt_sub_c" {
  subnet_id      = aws_subnet.mgnt_sub_c.id
  route_table_id = aws_route_table.pri_rt_c.id
}

## NodeGroup subnet
resource "aws_route_table_association" "node_sub_a" {
  subnet_id      = aws_subnet.node_sub_a.id
  route_table_id = aws_route_table.pri_rt_a.id
}

resource "aws_route_table_association" "node_sub_c" {
  subnet_id      = aws_subnet.node_sub_c.id
  route_table_id = aws_route_table.pri_rt_c.id
}