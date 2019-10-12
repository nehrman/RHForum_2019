data "aws_ami" "rhel" {
  count = "${var.cloud_provider == "aws" ? 1 : 0}"
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # Red Hat
}


