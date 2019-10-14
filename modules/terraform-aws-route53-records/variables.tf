variable "zone_id" {
  description = "the ID of Route53 Zone"
  type        = "string"
  default     = ""
}

variable "instance_name" {
  description = "List of Name which needs a record"
  type        = "list"
  default     = []
}

variable "record_type" {
  description = "Defines the type of record to create"
  type        = "string"
  default     = "A"
}

variable "record_ttl" {
  description = "Defines the type of record to create"
  type        = "string"
  default     = "300"
}

variable "instance_ip" {
  description = "List of IP addesses related to instances"
  type        = "list"
  default     = []
}
