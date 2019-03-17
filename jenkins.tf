resource "aws_instance" "jenkins_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.build_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.build_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "jenkins-vm"
    ResourceGroup = "${local.env}"
  }

  # provisioner "remote-exec" {
  #   connection {
  #     type        = "ssh"
  #     user        = "centos"
  #     private_key = "${file("dev-keypair.pem")}"
  #   }

  #   scripts = [
  #     "./scripts/update.sh",
  #     "./scripts/docker.sh",
  #   ]
  # }
}
