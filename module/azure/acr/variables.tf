variable "rg" {
  type    = azurerm_resource_group
}

variable "sku" {
  type = string
}

variable "admin_enabled" {
  type = bool
  default = false
}

variable "name" {
  type = string
}