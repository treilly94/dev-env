resource "aws_subnet" "access_subnet" {
  vpc_id                  = "${aws_vpc.dev_vpc.id}"
  cidr_block              = "${local.access_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "${local.env}-subnet"
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

resource "aws_instance" "access_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "dev-keypair"

  subnet_id       = "${aws_subnet.access_subnet.id}"
  security_groups = ["${aws_security_group.access_sg.id}"]
  depends_on      = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "access-vm"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
    ]
  }
}
