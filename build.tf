# Gitlab

resource "aws_instance" "gitlab_vm" {
  count = "${var.gitlab == "true" ? "1" : "0"}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t3.small"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.build_subnet.id}"
  private_ip             = "${local.hosts["gitlab"]}"
  vpc_security_group_ids = ["${aws_security_group.build_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "gitlab-vm"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.private_ip}"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"

      bastion_host        = "${aws_instance.access_vm.public_ip}"
      bastion_user        = "centos"
      bastion_private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
      "./scripts/gitlab.sh",
    ]
  }
}

# Jenkins

resource "aws_instance" "jenkins_vm" {
  count = "${var.jenkins == "true" ? "1" : "0"}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t3.micro"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.build_subnet.id}"
  private_ip             = "${local.hosts["jenkins"]}"
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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.private_ip}"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"

      bastion_host        = "${aws_instance.access_vm.public_ip}"
      bastion_user        = "centos"
      bastion_private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
      "./scripts/jenkins.sh",
    ]
  }
}

resource "aws_instance" "jenkins_agent" {
  count = "${var.jenkins_agent_count}"

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
    Name          = "${format("jenkins-agent%02d", count.index + 1)}"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.private_ip}"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"

      bastion_host        = "${aws_instance.access_vm.public_ip}"
      bastion_user        = "centos"
      bastion_private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
      "./scripts/jenkins_agent.sh",
    ]
  }
}

# Sonarqube

resource "aws_instance" "sonarqube_vm" {
  count = "${var.sonarqube == "true" ? "1" : "0"}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t3.small"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.build_subnet.id}"
  private_ip             = "${local.hosts["sonarqube"]}"
  vpc_security_group_ids = ["${aws_security_group.build_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "sonarqube-vm"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.private_ip}"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"

      bastion_host        = "${aws_instance.access_vm.public_ip}"
      bastion_user        = "centos"
      bastion_private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
      "./scripts/sonarqube.sh",
    ]
  }
}

# Vault

resource "aws_instance" "vault_agent" {
  count = "${var.vault == "true" ? "1" : "0"}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "dev-keypair"

  subnet_id              = "${aws_subnet.build_subnet.id}"
  private_ip             = "${local.hosts["vault"]}"
  vpc_security_group_ids = ["${aws_security_group.build_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "vault-vm"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.private_ip}"
      user        = "centos"
      private_key = "${file("dev-keypair.pem")}"

      bastion_host        = "${aws_instance.access_vm.public_ip}"
      bastion_user        = "centos"
      bastion_private_key = "${file("dev-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
      "./scripts/vault.sh",
    ]
  }
}
