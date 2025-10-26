#creating VPC
resource "aws_vpc" "vpc1" {
  description = "creating vpc to host public subnet and private subnet"
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
  availbility_zone = "${var.aws_region}a"
  tags = {
    Name = "vpc-private_subnet"
  }
  resource "aws_nat_gateway" "vpc-nat" {
    subnet_id = aws_subnet.public.id
    connectivity = "public"
    tags = {
      Name = "vpc-nat"
    }
    depends_on = [aws_internet_gateway.vpc-igw]
  }
  
  
  
