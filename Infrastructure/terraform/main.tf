#Create ssh key pair locally
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/ec2_key.pem"
  content  = tls_private_key.key.private_key_pem
}

# Create an SSH key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.key.public_key_openssh
}

# VPC Configuration
resource "aws_vpc" "arya" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "arya"
  }
}

# Public Subnet
resource "aws_subnet" "arya" {
  vpc_id                  = aws_vpc.arya.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "arya-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "arya" {
  vpc_id = aws_vpc.arya.id

  tags = {
    Name = "arya"
  }
}

# Route Table
resource "aws_route_table" "arya" {
  vpc_id = aws_vpc.arya.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.arya.id
  }

  tags = {
    Name = "arya"
  }
}

# Route Table Association
resource "aws_route_table_association" "arya" {
  subnet_id      = aws_subnet.arya.id
  route_table_id = aws_route_table.arya.id
}

# Security Group
resource "aws_security_group" "ssh_access" {
  name        = "allow-ssh"
  description = "Security group for arya server"
  vpc_id      = aws_vpc.arya.id

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
    Name = "arya"
  }
}

# EC2 Instance
resource "aws_instance" "arya" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  subnet_id                   = aws_subnet.arya.id
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true

  tags = {
    Name = "arya"
  }
}