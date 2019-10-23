variable "load_balancer_arn" {
  description = "the ARN of the Load Balancer"
  type        = "string"
  default     = ""
}

variable "listener_port" {
  description = "Defines the listener port"
  type        = "string"
  default     = ""
}

variable "listener_protocol" {
  description = "Defines the protocol used by the listener"
  type        = "string"
  default     = "HTTP"
}

variable "listener_ssl_policy" {
  description = "Defines the SSL policy when HTTPS is used as protocol"
  type        = "string"
  default     = ""
}

variable "listener_certificate_arn" {
  description = "The ARN of the certificate used for HTTPS"
  type        = "string"
  default     = ""
}

variable "target_group_arn" {
  description = "The ARN of the Target Group"
  type        = "string"
  default     = ""
}

variable "action_type" {
  description = "Defines the action type."
  type        = "string"
  default     = "forward"
}
