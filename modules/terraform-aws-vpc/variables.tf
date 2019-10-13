variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = "string"
  default     = ""
}

variable "internet_gateway" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = "true"
}

variable "single_nat_gateway" {
  description = "Controls if only one Nat Gateway should be deployed for all private subnets"
  type        = "string"
  default     = "true"
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want to deploy one Nat Gateway per availability zone. AZS must be set and the number of public subnets should equal or greater than the number of AZs"
  type        = "string"
  default     = "false"
}

variable "azs" {
  description = "Defines the name of availabity zone you want to configure"
  type        = "list"
  default     = []
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/8"
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true ti enable DNS hostnames in the Default VPC"
  type        = "string"
  default     = "true"
}

variable "vpc_enable_dns_support" {
  description = "Should be true ti enable DNS support in the Default VPC"
  type        = "string"
  default     = "true"
}

variable "vpc_public_subnet_cidr_block" {
  description = "A list of CIDRs used for each public subnets that you wan to create"
  type        = "list"
  default     = []
}

variable "vpc_subnet_map_public_ip_on_launch" {
  description = "Should be false if you don't want to automatically assign public ip on launch"
  default     = "true"
}

variable "vpc_private_subnet_cidr_block" {
  description = "A list of CIDRs used for each private subnets that you wan to create"
  type        = "list"
  default     = []
}

### TAGS VARIABLES

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

variable "vpc_tags" {
  description = "Additional Tags for VPC"
  type        = "map"
  default     = {}
}

variable "subnet_public_tags" {
  description = "Additional Tags for Public subnet"
  type        = "map"
  default     = {}
}

variable "subnet_private_tags" {
  description = "Additional Tags for Private subnet"
  type        = "map"
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional Tags for Public Route Table"
  type        = "map"
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional Tags for Private Route Table"
  type        = "map"
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Additional Tags for Nat Gateway Table"
  type        = "map"
  default     = {}
}

variable "internet_gateway_tags" {
  description = "Additional Tags for Internet Gateway"
  type        = "map"
  default     = {}
}
