resource "aws_key_pair" "ec2_key" {
  count = "${var.cloud_provider == "aws" ? 1 : 0}"

  key_name   = "${var.global_key_name}"
  public_key = "${var.ssh_public_key}"
}

resource "aws_instance" "vault_vm" {
  count = "${var.vault_vm_count * (var.cloud_provider == "aws" ? 1 : 0)}"

  ami                         = "${data.aws_ami.rhel.id}"
  instance_type               = "t2.medium"
  subnet_id                   = "${aws_subnet.ec2_subnet.id}"
  private_ip                  = "${cidrhost(aws_subnet.ec2_subnet.cidr_block, count.index + 100)}"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.ec2_sg.id}"]
  key_name                    = "${var.global_key_name}"

  root_block_device {
    volume_size = "50"
  }

  ebs_block_device {
    device_name = "sdf"
    volume_size = "100"
  }

  tags {
    Name        = "${var.global_vm_apps}-${var.global_environment}-vault-${count.index}"
    environment = "${var.global_environment}"
    owner       = "${var.global_owner}"
    purpose     = "vault"
    cloud       = "${var.cloud_provider}"
  }
}