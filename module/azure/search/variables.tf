variable "rg_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "free"
}

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "identity" {
  type    = string
  default = "SystemAssigned"
}