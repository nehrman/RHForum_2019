# Red Hat Forul-2019 - How to secure your secrets with Vault and Ansible Tower !!!

This demo was built as an interactive demonstration of the talk I did @ Red Hat Forum 2019 (Paris).

The main purpose was to demonstrate how you can leverage HashiCorp Vault to :
- Dynamically signed public key for ssh-ca enabling secure connection to managed nodes thru Ansible Tower
- Accessing Static Secrets inside a playbook
- Creating Dynamic Secrects used in playbooks

To do this, I decided to use Terraform to build the infrastructure shown below : 

WIP

In order to deploy correcty the demo, I splitted the code in different steps :
- Step 1 : Deploying AWS Based infrastructure
- Step 2 : Creating ACM Certificate
- Step 3 : Deploying Instances (Bastion, Vault , Tower and Managed Nodes)
- Step 4 : Configuring Load Balancer (Listener, Target Groups) and deploying Tower

## Authors

* **Nicolas Ehrman** - *Initial work* - [Hashicorp](https://www.hashicorp.com)