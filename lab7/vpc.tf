#how many availability zones do we have
data "aws_availability_zones" "available" {
  state = "available"
}

#new vpc
resource "aws_vpc" "devops-terraform-vpc" {
    cidr_block = "10.128.0.0/16"
    tags = {
        Name = "devops-terraform-vpc"
    }
}

#create subnets
resource "aws_subnet" "devops-public-subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.devops-terraform-vpc.id
    cidr_block = cidrsubnet(aws_vpc.devops-terraform-vpc.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "devops-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "devops-private-subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.devops-terraform-vpc.id
    cidr_block = cidrsubnet(aws_vpc.devops-terraform-vpc.cidr_block, 8, count.index + 3)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
    tags = {
        Name = "devops-private-subnet-${count.index + 1}"
    }
}

#create internet gateway
resource "aws_internet_gateway" "devops-terraform-ig" {
    vpc_id = aws_vpc.devops-terraform-vpc.id
    tags = {
        Name = "devops-terraform-ig"
    }
}
#create nat gateway
resource "aws_eip" "devops-terraform-eip" {
    domain = "vpc"
    tags = {
        Name = "devops-terraform-eip"
    }
}

resource "aws_nat_gateway" "devops-terraform-nat" {
    allocation_id = aws_eip.devops-terraform-eip.id
    subnet_id = aws_subnet.devops-public-subnet[0].id
    depends_on = [aws_internet_gateway.devops-terraform-ig, aws_eip.devops-terraform-eip]
    tags = {
        Name = "devops-terraform-nat"
    }
}

#create route tables
resource "aws_route_table" "devops-public-rt" {
    vpc_id = aws_vpc.devops-terraform-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.devops-terraform-ig.id
    }
    tags = {
        Name = "devops-public-rt"
    }
}

resource "aws_route_table" "devops-private-rt" {
    vpc_id = aws_vpc.devops-terraform-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.devops-terraform-nat.id
    }
    tags = {
        Name = "devops-private-rt"
    }
}

resource "aws_route_table_association" "devops-public-rt-assoc" {
    count = length(data.aws_availability_zones.available.names)
    subnet_id = aws_subnet.devops-public-subnet[count.index].id
    route_table_id = aws_route_table.devops-public-rt.id
}

resource "aws_route_table_association" "devops-private-rt-assoc" {
    count = length(data.aws_availability_zones.available.names)
    subnet_id = aws_subnet.devops-private-subnet[count.index].id
    route_table_id = aws_route_table.devops-private-rt.id
}

#create security groups
resource "aws_security_group" "devops-public-sg" {
    name = "devops-public-sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = aws_vpc.devops-terraform-vpc.id

    ingress {
        description = "Allow inbound traffic on port 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow inbound traffic on port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "devops-public-sg"
    }
}

resource "aws_security_group" "devops-private-sg" {
    name = "devops-private-sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = aws_vpc.devops-terraform-vpc.id

    ingress {
        description = "Allow inbound traffic on port 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow inbound traffic on port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "devops-private-sg"
    }
}

#deploye ec2 instances with webserver
resource "aws_instance" "devops-public-instance"{
    depends_on = [aws_route_table_association.devops-public-rt-assoc,aws_internet_gateway.devops-terraform-ig]
    count = 3
    ami = "ami-07887b6789db08b82"
    instance_type = "t3.micro"
    key_name = "student_new_keypair"
    security_groups = [aws_security_group.devops-public-sg.id]
    subnet_id = aws_subnet.devops-public-subnet[count.index].id
    user_data = file("setup1.sh")

    tags = {
        Name = "devops-public-instance-${count.index + 1}"
    }   

}

resource "aws_instance" "devops-private-instance"{
    depends_on = [aws_route_table_association.devops-private-rt-assoc, aws_nat_gateway.devops-terraform-nat]
    count = 3
    ami = "ami-07887b6789db08b82"
    instance_type = "t3.micro"
    key_name = "student_new_keypair"
    security_groups = [aws_security_group.devops-private-sg.id]
    subnet_id = aws_subnet.devops-private-subnet[count.index].id
    user_data = file("setup2.sh")

    tags = {
        Name = "devops-private-instance-${count.index + 1}"
    }   
    
}
#print output - urls
output "devops-public-instance-urls" {
    value = [for instance in aws_instance.devops-public-instance : "http://${instance.public_ip}"]
}

output "devops-private-instance-urls" {
    value = [for instance in aws_instance.devops-private-instance : "http://${instance.private_ip}"]
}
