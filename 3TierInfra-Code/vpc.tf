
#  creating vpc 

resource "aws_vpc" "three-tier" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "3-tietr-vpc"
    }
}
# for frontend load balancer 
resource "aws_subnet" "pub1" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.0.0/25"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet
    tags = {
    Name = "pub-1a"
  }
}
# for frontend load balancer 
resource "aws_subnet" "pub2" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.0.128/25"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet
    tags = {
    Name = "pub-2b"
  }
}
#fronend server
resource "aws_subnet" "prvt3" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.1.0/25"
    availability_zone = "ap-south-1a"
    tags = {
    Name = "prvt-3a"
  }
}
#fronend server
resource "aws_subnet" "prvt4" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.1.128/25"
    availability_zone = "ap-south-1b"
    tags = {
    Name = "prvt-4b"
  }
  
}
#Backend server 
resource "aws_subnet" "prvt5" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.2.0/25"
    availability_zone = "ap-south-1a"
    tags = {
    Name = "prvt-5a"
  }
}
# Backend Server 
resource "aws_subnet" "prvt6" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.2.128/25"
    availability_zone = "ap-south-1b"
    tags = {
    Name = "prvt-6b"
  }
}
#rds
resource "aws_subnet" "prvt7" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.3.0/25"
    availability_zone = "ap-south-1a"
    tags = {
    Name = "prvt-7a"
  }
}
#rds
resource "aws_subnet" "prvt8" {
    vpc_id = aws_vpc.three-tier.id
    cidr_block = "10.0.3.128/25"
    availability_zone = "ap-south-1b"
    tags = {
    Name = "prvt-8b"
  }
}
#  creating internet gateway

resource "aws_internet_gateway" "three-tier-ig" {
    vpc_id = aws_vpc.three-tier.id
    tags = {
        Name = "3-tier-ig"
    }
}
#  creating public route table

resource "aws_route_table" "three-tier-pub-rt" {
    vpc_id = aws_vpc.three-tier.id
    tags = {
      Name = "3-tier-pub-rt"
    }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three-tier-ig.id
  }
}

#  attaching pub-1a subnet to public route table
resource "aws_route_table_association" "public-1a" {
    route_table_id = aws_route_table.three-tier-pub-rt.id 
    subnet_id = aws_subnet.pub1.id
}

#  attaching pub-2b subnet to public route table
resource "aws_route_table_association" "public-2b" {
    route_table_id = aws_route_table.three-tier-pub-rt.id 
    subnet_id = aws_subnet.pub2.id
}



#  creating elastic ip for nat gateway

resource "aws_eip" "eip" {
  
}

#  creating nat gateway
resource "aws_nat_gateway" "cust-nat" {
  subnet_id = aws_subnet.pub1.id
  connectivity_type = "public"
  allocation_id = aws_eip.eip.id
  tags = {
    Name = "3-tier-nat"
  }
}

#  creating private route table 
resource "aws_route_table" "three-tier-prvt-rt" {
    vpc_id = aws_vpc.three-tier.id
    tags = {
      Name = "3-tier-private-rt"
    }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cust-nat.id
  }
}

#  attaching prvt-3a subnet to private route table
resource "aws_route_table_association" "prvivate-3a" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt3.id
}

#  attaching prvt-4b subnet to private route table
resource "aws_route_table_association" "prvivate-4b" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt4.id
}

#  attaching prvt-5a subnet to private route table
resource "aws_route_table_association" "prvivate-5a" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt5.id
}

#  attaching prvt-6b subnet to private route table
resource "aws_route_table_association" "prvivate-6b" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt6.id
}

#  attaching prvt-7a subnet to private route table
resource "aws_route_table_association" "prvivate-7a" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt7.id
}

#  attaching prvt-8b subnet to private route table
resource "aws_route_table_association" "prvivate-8b" {
    route_table_id = aws_route_table.three-tier-prvt-rt.id
    subnet_id = aws_subnet.prvt8.id
}