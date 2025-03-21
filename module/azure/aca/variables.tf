variable "rg_name" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "external_enabled" {
  type    = bool
  default = false
}