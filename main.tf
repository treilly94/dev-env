provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}

locals {
  env             = "Dev"
  default_vm_size = "t3.nano"
  vpc_cidr        = "10.0.0.0/16"
  access_cidr     = "${cidrsubnet(local.vpc_cidr,4,1)}" # 20
  build_cidr      = "${cidrsubnet(local.vpc_cidr,4,2)}" # 20

  hosts = {
    access    = "${cidrhost(local.access_cidr, 20)}"
    gitlab    = "${cidrhost(local.build_cidr, 20)}"
    jenkins   = "${cidrhost(local.build_cidr, 21)}"
    sonarqube = "${cidrhost(local.build_cidr, 22)}"
    vault     = "${cidrhost(local.build_cidr, 23)}"
    awx       = "${cidrhost(local.build_cidr, 24)}"
    openfass  = "${cidrhost(local.build_cidr, 25)}"
  }
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
