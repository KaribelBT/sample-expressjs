variable "DO_TOKEN" {
  type        = string
  description = "Digital Ocean authentication token"
  sensitive   = true
}

variable "ENV" {
  type        = string
  description = "Environment"
  default     = "development"
  validation {
    condition     = contains(["development", "staging", "production"], var.ENV)
    error_message = "Allowed values for ENV are \"development\", \"staging\", \"production\"."
  }
}

variable "PAPERTRAIL_ENDPOINT" {
  type        = string
  description = "Papertrail endpoint to send logs"
}
