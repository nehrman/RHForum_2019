resource "aws_instance" "vm" {
  count = "${var.vm_count}"

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  key_name                    = "${var.key_name}"
  monitoring                  = "${var.monitoring}"
  user_data                   = "${var.user_data}"

  root_block_device {
    delete_on_termination = "${lookup(var.root_block_device[count.index], "delete_on_termination", "")}"
    volume_type           = "${lookup(var.root_block_device[count.index], "volume_type", "")}"
    volume_size           = "${lookup(var.root_block_device[count.index], "volume_size", "")}"

    #   iops                  = "${lookup(var.root_block_device[count.index], "iops", "")}"
    encrypted  = "${lookup(var.root_block_device[count.index], "encrypted", "")}"
    kms_key_id = "${lookup(var.root_block_device[count.index], "kms_key_id", "")}"
  }

  ebs_block_device {
    delete_on_termination = "${lookup(var.ebs_block_device[count.index], "delete_on_termination", "")}"
    device_name           = "${lookup(var.ebs_block_device[count.index], "device_name", "")}"
    snapshot_id           = "${lookup(var.ebs_block_device[count.index], "snapshot_id", "")}"
    volume_type           = "${lookup(var.ebs_block_device[count.index], "volume_type", "")}"
    volume_size           = "${lookup(var.ebs_block_device[count.index], "volume_size", "")}"

    #  iops                  = "${lookup(var.ebs_block_device[count.index], "iops", "")}"
    encrypted  = "${lookup(var.ebs_block_device[count.index], "encrypted", "")}"
    kms_key_id = "${lookup(var.ebs_block_device[count.index], "kms_key_id", "")}"
  }

  tags = "${merge(var.tags, var.instance_tags)}"

  volume_tags = "${var.tags}"
}
