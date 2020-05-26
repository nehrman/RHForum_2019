resource "local_file" "tower_demo" {
  count    = var.tower_mode == "demo" ? 1 : 0 
  content  = templatefile("${path.module}/Templates/inventory_demo.tpl", {
    tower_hosts_def            = join("", var.tower_hosts)
    tower_setup_admin_password = var.tower_setup_admin_password
    tower_setup_pg_database    = var.tower_setup_pg_database
    tower_setup_pg_username    = var.tower_setup_pg_username
    tower_setup_pg_password    = var.tower_setup_pg_password
    tower_setup_rabbitmq_pass  = var.tower_setup_rabbitmq_pass
  })
  filename = "${path.module}/ansible/inventory"
}

resource "local_file" "tower_cluster" {
  count    = var.tower_mode == "cluster" ? 1 : 0 
  content  = templatefile("${path.module}/Templates/inventory_cluster.tpl", {
    tower_hosts_def            = var.tower_hosts
    isolated_hosts_def         = var.isolated_hosts
    postgresql_hosts_def       = var.postgresql_hosts
    postgresql_port            = var.tower_postgresql_port
    tower_setup_admin_password = var.tower_setup_admin_password
    tower_setup_pg_database    = var.tower_setup_pg_database
    tower_setup_pg_username    = var.tower_setup_pg_username
    tower_setup_pg_password    = var.tower_setup_pg_password
    tower_setup_rabbitmq_pass  = var.tower_setup_rabbitmq_pass
  })
  filename = "${path.module}/ansible/inventory"
}

resource "local_file" "tower_hosts" {
  content  = templatefile("${path.module}/Templates/hosts.tpl", {
    tower_hosts_def            = var.tower_hosts
  })
  filename = "${path.module}/ansible/hosts"
}


##
## here we create the list of available Tower Nodes
## to be used as input for the Inventory template
##

# data "template_file" "ansible_tower_hosts" {
#   count    = "${length(var.tower_hosts)}"
#   template = file("${path.module}/templates/tower_nodes.tpl")

#   vars = {
#     tower_hosts_name = element(var.tower_hosts, count.index)
#   }
# }

##
## here we create the list of available Tower Nodes
## to be used as input for the Hosts template
##

# data "template_file" "ansible_tower_host" {
#   count    = "${length(var.tower_hosts)}"
#   template = file("${path.module}/templates/tower_nodes.tpl")

#   vars = {
#     tower_hosts_name = element(var.tower_hosts, count.index)
#   }
# }

##
## here we create the list of available Isolated Nodes
## to be used as input for the Inventory template
##
# data "template_file" "ansible_isolated_hosts" {
#   count    = "${length(var.isolated_hosts)}"
#   template = file("${path.module}/templates/isolated_nodes.tpl")

#   vars = {
#     isolated_hosts_name = element(var.isolated_hosts, count.index)
#   }
# }

##
## here we create the list of available Isolated Nodes
## to be used as input for the Inventory template
##
# data "template_file" "ansible_postgresql_hosts" {
#   count    = "${length(var.postgresql_hosts)}"
#   template = file("${path.module}/templates/postgresql_nodes.tpl")

#   vars = {
#     postgresql_hosts_name = element(var.postgresql_hosts, count.index)
#   }
# }

##
## here we assign Tower, Isolated and Postgresql nodes to the right GROUP
## 
# data "template_file" "ansible_groups" {
#   template = file("${path.module}/templates/inventory.tpl")

#   vars = {
#     tower_hosts_def            = join("",data.template_file.ansible_tower_hosts.*.rendered)
#     isolated_hosts_def         = join("",data.template_file.ansible_isolated_hosts.*.rendered)
#     postgresql_hosts_def       = join("",data.template_file.ansible_postgresql_hosts.*.rendered)
#     postgresql_port            = var.tower_postgresql_port
#     tower_setup_admin_password = var.tower_setup_admin_password
#     tower_setup_pg_database    = var.tower_setup_pg_database
#     tower_setup_pg_username    = var.tower_setup_pg_username
#     tower_setup_pg_password    = var.tower_setup_pg_password
#     tower_setup_rabbitmq_pass  = var.tower_setup_rabbitmq_pass
#   }
# }

##
## here we assign Tower nodes to the right GROUP
## 
# data "template_file" "ansible_tower_group" {
#   template = file("${path.module}/templates/hosts.tpl")

#   vars = {
#     tower_host_def = join("",data.template_file.ansible_tower_host.*.rendered)
#   }
# }

##
## here we write the rendered "ansible_groups" template into a local file
## on the Terraform exec environment (the shell where the terraform binary runs)
##
# resource "local_file" "ansible_inventory" {
#   depends_on = [data.template_file.ansible_groups]

#   content  = data.template_file.ansible_groups.rendered
#   filename = "${path.module}/ansible/inventory"
# }

##
## here we write the rendered "ansible_groups" template into a local file
## on the Terraform exec environment (the shell where the terraform binary runs)
##
# resource "local_file" "ansible_host" {
#   depends_on = [data.template_file.ansible_tower_group]

#   content  = data.template_file.ansible_tower_group.rendered
#   filename = "${path.module}/ansible/hosts"
# }

##
## here we create the Ansible Configuration 
## to be used by Ansible 
##
# data "template_file" "ansible_cfg" {
#   template = file("${path.module}/templates/ansible_cfg.tpl")

#   vars = {
#     ansible_user = var.global_admin_username
#   }
# }

resource "local_file" "ansible_cfg" {
  content  = templatefile("${path.module}/Templates/ansible_cfg.tpl", {
    ansible_user = var.global_admin_username
  })
  filename = "${path.module}/ansible/.ansible.cfg"
}
##
## here we write the rendered ansible configuration
## on the Terraform exec environment (the shell where the terraform binary runs)
##
# resource "local_file" "ansible_cfg" {
#   depends_on = [data.template_file.ansible_cfg]

#   content  = data.template_file.ansible_cfg.rendered
#   filename = "${path.module}/ansible/.ansible.cfg"
# }

##
## here we create the customize the Ansible playbook
## to be used as input for Ansible deployment
##
# data "template_file" "ansible_site" {
#   template = file("${path.module}/templates/site.tpl")

#   vars = {
#     setup_version              = var.tower_setup_version
#     setup_dir                  = var.tower_setup_dir
#     tower_host_name            = element(var.tower_hosts, 0)
#     tower_setup_admin_password = var.tower_setup_admin_password
#     tower_setup_admin_user     = var.tower_setup_admin_user
#     tower_license              = jsonencode(merge(var.tower_license,var.tower_eula))
#     tower_verify_ssl           = var.tower_verify_ssl
#     tower_body_format          = var.tower_body_format
#   }
# }

resource "local_file" "ansible_site" {
  content  = templatefile("${path.module}/Templates/site.tpl", {
    setup_version              = var.tower_setup_version
    setup_dir                  = var.tower_setup_dir
    tower_host_name            = element(var.tower_hosts, 0)
    tower_setup_admin_password = var.tower_setup_admin_password
    tower_setup_admin_user     = var.tower_setup_admin_user
    tower_license              = var.tower_license
    tower_verify_ssl           = var.tower_verify_ssl
    tower_body_format          = var.tower_body_format
  })
  filename = "${path.module}/ansible/site.yml"
}

##
## here we copy the local file to the bastion
## using a "null_resource" to be able to trigger a file provisioner
##
resource "null_resource" "ansible_copy" {
  depends_on = [local_file.tower_demo,local_file.tower_cluster, local_file.tower_hosts, local_file.ansible_site]

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "${path.module}/ansible/"
    destination = "~/"

    connection {
      type        = "ssh"
      host        = var.bastion_host[0]
      user        = var.global_admin_username
      private_key = file(var.id_rsa_path)
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
    content     = file(var.id_rsa_path)
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      host        = var.bastion_host[0]
      user        = var.global_admin_username
      private_key = file(var.id_rsa_path)
      insecure    = true
    }
  }
}

resource "null_resource" "ansible_run" {
  depends_on = [null_resource.ansible_ssh_id,null_resource.ansible_copy,local_file.tower_demo,local_file.tower_cluster, local_file.tower_hosts]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = var.bastion_host[0]
    user        = var.global_admin_username
    private_key = file(var.id_rsa_path)
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
