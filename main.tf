

variable "cidr_block" {  
    description = "my vpc vaiable"
    default = ["10.0.0.0/16", "10.10.0.0/16"]
    type = list(string)
}

variable "sub_cidrblock" {
    description = "my private subnet cidr-block"
}
 variable "environment" {
    description = "my tags"
   
 }


resource "aws_vpc" "developement-vpc" {
    cidr_block = var.cidr_block[0]

    tags = {
      name : var.environment
    }
}

# data "aws_vpc" "exixting" {
#     id = "vpc-08eb7351183fa6fb8"
# }
resource "aws_subnet" "dev-subnet-4" {
    vpc_id = aws_vpc.developement-vpc.id
    cidr_block = var.sub_cidrblock
    availability_zone = "us-east-1b"

    tags = {
        name : var.environment
    }
}

output "dev_vpc_id" {
    value = aws_vpc.developement-vpc.id 
}
 output "dev-subnet-id" {
    value= aws_subnet.dev-subnet-4.id 
 }

  
