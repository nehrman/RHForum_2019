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
