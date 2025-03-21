variable "rg_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}