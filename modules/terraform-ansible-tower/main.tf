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

resource "local_file" "ansible_cfg" {
  content  = templatefile("${path.module}/Templates/ansible_cfg.tpl", {
    ansible_user = var.global_admin_username
  })
  filename = "${path.module}/ansible/.ansible.cfg"
}

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
