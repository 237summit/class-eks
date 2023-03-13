resource "aws_subnet" "pub_sub_a" {
  vpc_id                  = aws_vpc.weplat-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true # public IP 자동 할당

  tags = {
    Name = "weplat-pub-sub-2a"
  }
}

resource "aws_subnet" "pub_sub_c" {
  vpc_id                  = aws_vpc.weplat-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true # Public IP 자동 할당

  tags = {
    Name = "weplat-pub-sub-2c"
  }
}

resource "aws_subnet" "mgnt_sub_a" {
  vpc_id            = aws_vpc.weplat-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "weplat-mgnt-sub-2a"
  }
}

resource "aws_subnet" "mgnt_sub_c" {
  vpc_id            = aws_vpc.weplat-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "weplat-mgnt-sub-2c"
  }
}

resource "aws_subnet" "node_sub_a" {
  vpc_id            = aws_vpc.weplat-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "weplat-node-sub-2a"
  }
}

resource "aws_subnet" "node_sub_c" {
  vpc_id            = aws_vpc.weplat-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "weplat-node-sub-2c"
  }
}
