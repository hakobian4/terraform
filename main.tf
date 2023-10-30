resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags       = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.myapp-vpc.id
  subnet_cidr_blocks     = var.subnet_cidr_blocks
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp-vpc.id
  my_ip               = var.my_ip
  env_prefix          = var.env_prefix
  image_name          = var.image_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  subnet_id           = module.myapp-subnet.subnet.id
  avail_zone          = var.avail_zone
}

