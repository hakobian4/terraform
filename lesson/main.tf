# there are 2 ways to set environment variables
# 1) export variable as a machine environment variable: AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID
# 2) export variable as a terraform environment variable. variable name has to be started at "TF_VAR_" (TF_VAR_avail_zone)


provider "aws" {}

# there are 3 ways to pass variable
# 1) pass it after running "terraform apply" command
# 2) pass it in "terraform apply" command. in this case 'terraform apply -var "subnet_cidr_block=10.0.20.0/24"'
# 3) define variable in "terraform.tfvars" file: this is the most efficient and correct way
# NOTE: if variables file name is not "terraform.tfvars" it has to be passed to apply command like this:
#       "terraform apply -var-file terraform-dev.tfvars"
variable "cidr_blocks" {
  description = "cidr blocks and name tags for vpc and subnets"
  type = list(object({
    cidr_block=string
    name=string
  }))
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags       = {
    Name : var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = var.avail_zone
  tags              = {
    Name : var.cidr_blocks[1].name
  }
}

variable "avail_zone" {}

# get existing vpc
#data "aws_vpc" "existing_vpc" {
#  default = false
#}
#
#resource "aws_subnet" "dev-subnet-2" {
#  vpc_id            = data.aws_vpc.existing_vpc.id
#  cidr_block        = "10.0.26.0/24"
#  availability_zone = "eu-west-3a"
#  tags              = {
#    Name : "subnet-2-dev"
#  }
#}

# define outputs to see created resources values
#output "dev-vpc-id" {
#  value = aws_vpc.development-vpc.id
#}
#
#output "dev-subnet-id" {
#  value = aws_subnet.dev-subnet-1.id
#}
