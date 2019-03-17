resource "aws_subnet" "access_subnet" {
  vpc_id                  = "${aws_vpc.dev_vpc.id}"
  cidr_block              = "${local.access_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "${local.env}-access-subnet"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table_association" "access_route_table_association" {
  subnet_id      = "${aws_subnet.access_subnet.id}"
  route_table_id = "${aws_route_table.dev_route_table.id}"
}

resource "aws_security_group" "access_sg" {
  name        = "access_security_group"
  description = "Security rules for the access vms"
  vpc_id      = "${aws_vpc.dev_vpc.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # VPN
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name          = "access-security-group"
    ResourceGroup = "${local.env}"
  }
}
