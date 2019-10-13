variable "name" {
  description = "The name of the security group"
  type        = "string"
  default     = ""
}

variable "description" {
  description = "Describe your security group"
  type        = "string"
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "Default tags used by any resources"
  type        = "map"

  default = {
    "Name"        = "RHForum2019"
    "owner"       = "nehrman"
    "purpose"     = "demo"
    "environment" = "production"
  }
}

variable "cidr_blocks" {
  description = "List of cidr_blocks"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "custom_security_rules" {
  description = "Lists of rules to configure security group"
  type        = "list"

  default = [
    {
      type        = "ingress"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      description = "SSH access TFE"
    },
    {
      type        = "ingress"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      description = "HTTP access Vault"
    },
    {
      type = "egress"

      from_port   = "0"
      to_port     = "65535"
      protocol    = "-1"
      description = "Allow all"
    },
  ]
}
