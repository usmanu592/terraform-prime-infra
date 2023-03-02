resource "aws_vpc" "prime" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prime"
  }
}

#to creating igw
# https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "prime-igw" {
  vpc_id = aws_vpc.prime.id

  tags = {
    Name = "prime-igw"
  }
}

# to creating a public subnet 1
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html

resource "aws_subnet" "prime-pub1" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prime-pub1"
  }
}

# creating of public subnet 2

resource "aws_subnet" "prime-pub2" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prime-pub2"
  }
}

# creating a route table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table.html

resource "aws_route_table" "prime-pub-route-table" {
  vpc_id = aws_vpc.prime.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prime-igw.id
  }

  tags = {
    Name = "prime-pub-route-table"
  }
}


# associating subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-pub1" {
  subnet_id      = aws_subnet.prime-pub1.id
  route_table_id = aws_route_table.prime-pub-route-table.id
}

# associating subnet 2
resource "aws_route_table_association" "prime-pub2" {
  subnet_id      = aws_subnet.prime-pub2.id
  route_table_id = aws_route_table.prime-pub-route-table.id
}

# creating a private subnet 1
resource "aws_subnet" "prime-private1" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prime-private1"
  }
}

# creating a private subnet 2

resource "aws_subnet" "prime-private2" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prime-private2"
  }
}

# creating a route table

resource "aws_route_table" "private-route_table" {
  vpc_id = aws_vpc.prime.id

  route = []

  tags = {
    Name = "prime-private-route-table"
  }
}

# associating my private route-table

resource "aws_route_table_association" "prime-private1" {
  subnet_id      = aws_subnet.prime-private1.id
  route_table_id = aws_route_table.private-route_table.id
}

# associating my private route-table
resource "aws_route_table_association" "prime-private2" {
  subnet_id      = aws_subnet.prime-private2.id
  route_table_id = aws_route_table.private-route_table.id
}