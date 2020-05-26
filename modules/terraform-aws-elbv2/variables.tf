### Common variables

variable "name" {
  description = "The name of LB"
  type        = string
  default     = "LB"
}

variable "internal" {
  description = "Should be false if you want to have an external LB"
  type        = string
  default     = "false"
}

variable "lb_type" {
  description = "Controls the type of LB. You can choose between network and application"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "List of Security Groups for your LB"
  type        = list
  default     = []
}

variable "enable_deletion_protection" {
  description = "Should be true if you want to protect the LB against deletion by Terraform"
  type        = string
  default     = "false"
}

variable "ip_address_type" {
  description = "Controls which type of IP adresses is used by the subnets of the LB. Possible Values are ipv4 and dualstack"
  type        = string
  default     = "ipv4"
}

variable "access_logs" {
  description = "Map for configuring access logs"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "List of the ID of the subnets of which attach to the Load Balancer"
  type        = list(string)
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

### Network Load Balancer specific variables

variable "enable_cross_zone_load_balancing" {
  description = "Should be true if you want the LB to be cross zone. Only for Network LoadBalancer"
  type        = string
  default     = "false"
}

### Application Load Balancer specific variables

variable "idle_timeout" {
  description = "Controls the time in seconds that the connection is allowed to be idle"
  type        = string
  default     = "60"
}

variable "enable_http2" {
  description = "Should be true if you want to indicate if HTTP/2 needs to be enabled on Application Load Balancer"
  type        = string
  default     = "true"
}
