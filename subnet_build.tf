resource "aws_subnet" "build_subnet" {
  vpc_id                  = "${aws_vpc.dev_vpc.id}"
  cidr_block              = "${local.build_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "${local.env}-build-subnet"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table_association" "build_route_table_association" {
  subnet_id      = "${aws_subnet.build_subnet.id}"
  route_table_id = "${aws_route_table.dev_route_table.id}"
}

resource "aws_security_group" "build_sg" {
  name        = "build_security_group"
  description = "Security rules for the build vms"
  vpc_id      = "${aws_vpc.dev_vpc.id}"

  # Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  tags = {
    Name          = "build-security-group"
    ResourceGroup = "${local.env}"
  }
}
