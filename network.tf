# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = join(",", var.aws_vpc_cidr)
}

resource "aws_subnet" "pubsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = join(",", var.aws_pubsub_cidr)

  tags = {
    Name = "public subnet"
  }
}

resource "aws_subnet" "pvtsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = join(",", var.aws_pvtsub_cidr)

  tags = {
    Name = "pvt subnet"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rtpub" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public route table"
  }
}

resource "aws_route_table_association" "pubassn" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.rtpub.id
}

resource "aws_eip" "myeip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.pubsub.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "rtpvt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "pvtassn" {
  subnet_id      = aws_subnet.pvtsub.id
  route_table_id = aws_route_table.rtpvt.id
}

resource "aws_security_group" "pubsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.aws_vpc_cidr
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.aws_vpc_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "pvtsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.aws_vpc_cidr
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.aws_vpc_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "public" {
  ami                    = "ami-08b993f76f42c3e2f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pubsub.id
  vpc_security_group_ids = [aws_security_group.pubsg.id]

  tags = {
    Name = "Public TFM"
  }
}

resource "aws_instance" "private" {
  ami                    = "ami-08b993f76f42c3e2f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pvtsub.id
  vpc_security_group_ids = [aws_security_group.pvtsg.id]

  tags = {
    Name = "Private TFM"
  }
}
