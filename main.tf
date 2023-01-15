

variable "vpc_cidr_block" { }
variable "sub_cidr-block" {}
variable "availability_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "key_pair" {}
variable "myapp_ami" {}
  
resource "aws_vpc" "developement-vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
      name : "${var.env_prefix}-vpc"
    }
}


resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.developement-vpc.id
    cidr_block = var.sub_cidr-block
    availability_zone = var.availability_zone

    tags = {
        name :"${var.env_prefix}-subnet-1"
    }
}

  resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.developement-vpc.id
    route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.myapp-igw.id
    } 
  
    tags = {
      "name" = "${var.env_prefix}-rt"
      
    }
}
 

 resource "aws_internet_gateway" "myapp-igw" {
    vpc_id =  aws_vpc.developement-vpc.id

    tags = {
      "name" = "${var.env_prefix}-igw"
    }
 }
 
resource "aws_route_table_association" "myapp-rtass" {
  route_table_id = aws_route_table.myapp-route-table.id
  subnet_id = aws_subnet.myapp-subnet-1.id
}

 resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id      = aws_vpc.developement-vpc.id
   
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }
 
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
      "name" = "${var.env_prefix}-ssg"
    }
 } 


 resource "aws_instance" "this" {
  ami                   =  var.myapp_ami
  instance_type        = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.availability_zone
  associate_public_ip_address =  true
  key_name = var.key_pair

  user_data = file("entry-sript.sh")

   tags = {
      name = "${var.env_prefix}- server"  
    
    }
}




   