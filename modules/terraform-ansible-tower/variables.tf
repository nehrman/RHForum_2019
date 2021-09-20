variable "global_admin_username" {
  description = "Username used to connect thru ssh to instance"
  type        = string
  default     = "ec2-user"
}

variable "tower_setup_version" {
  description = "Defines Ansible Tower Version to deploy"
  type        = string
  default     = "3.8.2-1"
}

variable "tower_setup_dir" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = string
  default     = "."
}

variable "tower_hosts" {
  description = "List of Tower Hosts"
  type        = list(string)
  default     = []
}

variable "isolated_hosts" {
  description = "List of Isolated Nodes"
  type        = list
  default     = []
}

variable "postgresql_hosts" {
  description = "List of PosqtgreSQL Hosts"
  type        = list
  default     = []
}

variable "bastion_host" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = list
  default     = []
}

variable "id_rsa_path" {
  description = "Defines the path to Ansible Tower Setup Directory"
  type        = string
  default     = "~/.ssh/id_rsa_az"
}

variable "tower_setup_admin_user" {
  description = "Defines the administrator username used by Tower"
  type        = string
  default     = "admin"
}

variable "tower_setup_admin_password" {
  description = "Defines the administrator password used by Tower"
  type        = string
  default     = "tower"
}

variable "tower_postgresql_port" {
  description = "Defines the PostgreSQL port used by Tower"
  type        = string
  default     = "5432"
}

variable "tower_setup_pg_database" {
  description = "Defines the postgresql database name used by Tower"
  type        = string
  default     = "tower"
}

variable "tower_setup_pg_username" {
  description = "Defines the postgresql user name used by Tower"
  type        = string
  default     = "tower"
}

variable "tower_setup_pg_password" {
  description = "Defines the postgresql password used by Tower"
  type        = string
  default     = "tower"
}

variable "tower_setup_rabbitmq_pass" {
  description = "Defines the RabbitMQ password used by Tower"
  type        = string
  default     = "tower"
}

variable "tower_license" {
  description = "Defines The license used by Tower"
  type        = string
}

variable "tower_verify_ssl" {
  description = "Defines if Certficiate validation should be done"
  type        = string
  default     = "false"
}

variable "tower_body_format" {
  description = "Defines the body format used by Asnible URI module"
  type        = string
  default     = "json"
}

variable "tower_mode" {
  description = "Defines in which mode Tower will be deployed. Value must be demo or cluster"
  type        = string
  default     = "demo"
}
