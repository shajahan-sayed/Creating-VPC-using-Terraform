#creating VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc1"
  }
}
#creating Internet gateway
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "vpc-igw"
  }
}
#creating public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "vpc-public-subnet"
  }
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "vpc-private_subnet"
  }
}
  resource "aws_nat_gateway" "vpc-nat" {
    subnet_id = aws_subnet.public.id
    connectivity_type = "public"
    tags = {
      Name = "vpc-nat"
    }
    depends_on = [aws_internet_gateway.vpc-igw]
  }
#Route table for public 
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "public_route"
  }
}
#Route for IGW
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-igw.id
}
# Associate Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "private_route"
  }
}
# Route for NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-nat.id
}
# Associate Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
#creating security group
resource "aws_security_group" "vpc-sg" {
   name        = "vpc-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-sg"
  }
}

# EC2 Instance - Public
resource "aws_instance" "public_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "public-instance"
  }
}

# EC2 Instance - Private
resource "aws_instance" "private_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-sg.id]

  tags = {
    Name = "private-instance"
  }
}
