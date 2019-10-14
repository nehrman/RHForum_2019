variable "target_group_name" {
  description = "The name of the Target Groupe"
  type        = "string"
  default     = ""
}

variable "target_group_port" {
  description = "Defines the port utilzed by the Target Group"
  type        = "string"
  default     = "80"
}

variable "target_group_protocol" {
  description = "Defines the type of record to create"
  type        = "string"
  default     = "HTTP"
}

variable "vpc_id" {
  description = "The ID of the VPC where to create the target group"
  type        = "string"
  default     = ""
}

variable "target_type" {
  description = "Defines the type of target in the group"
  type        = "string"
  default     = "instance"
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

variable "instance_id" {
  description = "The ID of the instances"
  type        = "list"
  default     = []
}
