resource "aws_instance" "access_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.access_subnet.id}"
  private_ip             = "${local.hosts["access"]}"
  vpc_security_group_ids = ["${aws_security_group.access_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]
  source_dest_check      = false                                  # Needed for the vpn connection

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
      "./scripts/vpn.sh",
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./dev-keypair.pem centos@${aws_instance.access_vm.public_ip}:~/dev.ovpn ."
  }
}
