####### variables.tf #######

variable "public_zone_name" {
  description = "Domain or Subdomain name for which to create public zone"
  type        = list
  default     = []
}

variable "public_subzone_name" {
  description = "Domain or Subdomain name for which to create public subzone"
  type        = list
  default     = []
}

variable "private_zone_name" {
  description = "Domain or Subdomain name for which to create private zone"
  type        = list
  default     = []
}

variable "zone_id" {
  description = "Zone ID where to create the public subzone"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID where to create the private zone"
  type        = string
  default     = ""
}

variable "comment" {
  description = "The Zone Comment that should be added to all managed zones"
  type        = list
  default     = []
}

variable "tags" {
  description = "Default tags used by any resources"
  type        = map

  default = {
    "Name"        = "RHForum2019"
    "owner"       = "nehrman"
    "purpose"     = "demo"
    "environment" = "production"
  }
}
