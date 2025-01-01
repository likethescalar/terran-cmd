variable "global_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "ami" {
  type = string
}

variable "subnet" {
  type = string
}
