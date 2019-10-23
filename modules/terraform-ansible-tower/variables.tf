variable "global_admin_username" {
  description = "Username used to connect thru ssh to instance"
  type        = "string"
  default     = "ec2-user"
}

variable "tower_setup_version" {
  description = "Defines Ansible Tower Version to deploy"
  type        = "string"
  default     = "3.5.3-1.el7"
}

variable "tower_setup_dir" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = "string"
  default     = "."
}

variable "aws_tower_hosts" {
  description = "List of Tower Hosts"
  type        = "list"
  default     = []
}

variable "aws_isolated_hosts" {
  description = "List of Isolated Nodes"
  type        = "list"
  default     = []
}

variable "aws_postgresql_hosts" {
  description = "List of PosqtgreSQL Hosts"
  type        = "list"
  default     = []
}

variable "aws_bastion_host" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = "list"
  default     = []
}

variable "id_rsa_path" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = "string"
  default     = "./id-rsa_az"
}

variable "tower_setup_admin_password" {
  description = "Defines the administrator password used by Tower"
  type        = "string"
  default     = "tower"
}

variable "tower_setup_pg_database" {
  description = "Defines the postgresql database name used by Tower"
  type        = "string"
  default     = "tower"
}

variable "tower_setup_pg_username" {
  description = "Defines the postgresql user name used by Tower"
  type        = "string"
  default     = "tower"
}

variable "tower_setup_pg_password" {
  description = "Defines the postgresql password used by Tower"
  type        = "string"
  default     = "tower"
}

variable "tower_setup_rabbitmq_pass" {
  description = "Defines the RabbitMQ password used by Tower"
  type        = "string"
  default     = "tower"
}
