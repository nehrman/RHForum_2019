##
## here we create the list of available Tower Nodes
## to be used as input for the Inventory template
##

data "template_file" "ansible_tower_hosts" {
  count    = "${length(var.aws_tower_hosts)}"
  template = "${file("${path.module}/templates/tower_nodes.tpl")}"

  vars {
    tower_hosts_name = "${element(var.aws_tower_hosts, count.index)}"
  }
}

##
## here we create the list of available Tower Nodes
## to be used as input for the Hosts template
##

data "template_file" "ansible_tower_host" {
  count    = "${length(var.aws_tower_hosts)}"
  template = "${file("${path.module}/templates/tower_nodes.tpl")}"

  vars {
    tower_hosts_name = "${element(var.aws_tower_hosts, 0)}"
  }
}

##
## here we create the list of available Isolated Nodes
## to be used as input for the Inventory template
##
data "template_file" "ansible_isolated_hosts" {
  count    = "${length(var.aws_isolated_hosts)}"
  template = "${file("${path.module}/templates/isolated_nodes.tpl")}"

  vars {
    isolated_hosts_name = "${element(var.aws_isolated_hosts, count.index)}"
  }
}

##
## here we create the list of available Isolated Nodes
## to be used as input for the Inventory template
##
data "template_file" "ansible_postgresql_hosts" {
  count    = "${length(var.aws_postgresql_hosts)}"
  template = "${file("${path.module}/templates/postgresql_nodes.tpl")}"

  vars {
    postgresql_hosts_name = "${element(var.aws_postgresql_hosts, count.index)}"
  }
}

##
## here we assign Tower, Isolated and Postgresql nodes to the right GROUP
## 
data "template_file" "ansible_groups" {
  template = "${file("${path.module}/templates/inventory.tpl")}"

  vars {
    tower_hosts_def            = "${join("",data.template_file.ansible_tower_hosts.*.rendered)}"
    isolated_hosts_def         = "${join("",data.template_file.ansible_isolated_hosts.*.rendered)}"
    postgresql_hosts_def       = "${join("",data.template_file.ansible_postgresql_hosts.*.rendered)}"
    tower_setup_admin_password = "${ var.tower_setup_admin_password }"
    tower_setup_pg_database    = "${ var.tower_setup_pg_database }"
    tower_setup_pg_username    = "${ var.tower_setup_pg_username }"
    tower_setup_pg_password    = "${ var.tower_setup_pg_password }"
    tower_setup_rabbitmq_pass  = "${ var.tower_setup_rabbitmq_pass }"
  }
}

##
## here we assign Tower, Isolated and Postgresql nodes to the right GROUP
## 
data "template_file" "ansible_tower_group" {
  template = "${file("${path.module}/templates/hosts.tpl")}"

  vars {
    tower_host_def = "${join("",data.template_file.ansible_tower_host.*.rendered)}"
  }
}

##
## here we write the rendered "ansible_groups" template into a local file
## on the Terraform exec environment (the shell where the terraform binary runs)
##
resource "local_file" "ansible_inventory" {
  depends_on = ["data.template_file.ansible_groups"]

  content  = "${data.template_file.ansible_groups.rendered}"
  filename = "${path.module}/ansible/inventory"
}

##
## here we write the rendered "ansible_groups" template into a local file
## on the Terraform exec environment (the shell where the terraform binary runs)
##
resource "local_file" "ansible_host" {
  depends_on = ["data.template_file.ansible_tower_group"]

  content  = "${data.template_file.ansible_tower_group.rendered}"
  filename = "${path.module}/ansible/hosts"
}

##
## here we create the Ansible Configuration 
## to be used by Ansible 
##
data "template_file" "ansible_cfg" {
  template = "${file("${path.module}/templates/ansible_cfg.tpl")}"

  vars {
    ansible_user = "${var.global_admin_username}"
  }
}

##
## here we write the rendered ansible configuration
## on the Terraform exec environment (the shell where the terraform binary runs)
##
resource "local_file" "ansible_cfg" {
  depends_on = ["data.template_file.ansible_cfg"]

  content  = "${data.template_file.ansible_cfg.rendered}"
  filename = "${path.module}/ansible/.ansible.cfg"
}

##
## here we create the customize the Ansible playbook
## to be used as input for Ansible deployment
##
data "template_file" "ansible_site" {
  #  count      = "${var.az_consul_nb_instance}"
  template = "${file("${path.module}/templates/site.tpl")}"

  vars {
    setup_version = "${var.tower_setup_version}"
    setup_dir     = "${var.tower_setup_dir}"
  }
}

##
## here we write the rendered "site" playbook template into a local file
## on the Terraform exec environment (the shell where the terraform binary runs)
##
resource "local_file" "ansible_playbook" {
  depends_on = ["data.template_file.ansible_site"]

  content  = "${data.template_file.ansible_site.rendered}"
  filename = "${path.module}/ansible/site.yml"
}

##
## here we copy the local file to the bastion
## using a "null_resource" to be able to trigger a file provisioner
##
resource "null_resource" "ansible_copy" {
  depends_on = ["local_file.ansible_inventory", "local_file.ansible_playbook"]

  triggers {
    always_run = "${timestamp()}"
  }

  provisioner "file" {
    source      = "${path.module}/ansible/"
    destination = "~/"

    connection {
      type        = "ssh"
      host        = "${var.aws_bastion_host[0]}"
      user        = "${var.global_admin_username}"
      private_key = "${file(var.id_rsa_path)}"
      insecure    = true
    }
  }
}

##
## here we copy the local file to the bastion
## using a "null_resource" to be able to trigger a file provisioner
##
resource "null_resource" "ansible_ssh_id" {
  provisioner "file" {
    content     = "${file(var.id_rsa_path)}"
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      host        = "${var.aws_bastion_host[0]}"
      user        = "${ var.global_admin_username }"
      private_key = "${file(var.id_rsa_path)}"
      insecure    = true
    }
  }
}

resource "null_resource" "ansible_run" {
  depends_on = ["null_resource.ansible_ssh_id", "null_resource.ansible_copy", "local_file.ansible_inventory"]

  triggers {
    always_run = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    host        = "${var.aws_bastion_host[0]}"
    user        = "${var.global_admin_username}"
    private_key = "${file(var.id_rsa_path)}"
    insecure    = true
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0600 ~/.ssh/id_rsa",
      "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras",
      "sudo yum install -y ansible",
      "sleep 30 && ansible-playbook -i ~/hosts ~/site.yml ",
    ]
  }
}
