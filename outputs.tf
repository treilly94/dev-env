output "Ips" {
  value = "${aws_instance.access_vm.public_ip}"
}
