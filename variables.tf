variable "tower_license" {
  description = "Defines The license used by Tower"
  type        = "map"
  default     = {}
}

variable "tower_eula" {
  description = "Accepts the EULA used by Tower"
  type        = "map"
  default     = {}
}
