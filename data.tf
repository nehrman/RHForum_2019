data "aws_ami" "ami" {
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

 data "template_file" "config_ssh_target_host" {
   template = file("${path.module}/templates/vault_ssh_ca_client.tpl")

   vars = {
     vault_fqdn = module.aws_instance_vault.instance_private_dns[0]
   }
} 

