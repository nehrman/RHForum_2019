####### variables.tf #######

variable "public_zone_name" {
    description = "Domain or Subdomain name for which to create public zone"
    type = "list"
    default = []
}   

variable "comment" {
    description = "The Zone Comment that should be added to all managed zones"
    type = "string"
    default =""
}

variable "tags" {
    description = "Default tags used by any resources"
    type = "map"
    default = {
        "Name"  = "RHForum2019",
        "owner" = "nehrman",
        "purpose" = "demo",
        "environment" = "production"
    }
}
