provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}

locals {
  env             = "Dev"
  default_vm_size = "t3.nano"
  vpc_cidr        = "10.0.0.0/16"
  access_cidr     = "${cidrsubnet(local.vpc_cidr,4,3)}" # 20
  build_cidr      = "${cidrsubnet(local.vpc_cidr,4,4)}" # 20
}

data "aws_ami" "centos" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = "${local.vpc_cidr}"

  tags = {
    Name          = "${local.env}-vpc"
    ResourceGroup = "${local.env}"
  }
}

# For internet access
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.dev_vpc.id}"

  tags = {
    Name          = "${local.env}-gateway"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = "${aws_vpc.dev_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name          = "${local.env}-route-table"
    ResourceGroup = "${local.env}"
  }
}
