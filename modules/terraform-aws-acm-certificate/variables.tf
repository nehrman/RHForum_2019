variable "acm_domain_name" {
  description = "Defines the name of Domain to use as certificate"
  type        = "string"
  default     = ""
}

variable "acm_san" {
  description = "List of Domain Names to add in the certificate"
  type        = "list"
  default     = []
}

variable "acm_validation_method" {
  description = "Defines the validation method."
  type        = "string"
  default     = "DNS"
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
