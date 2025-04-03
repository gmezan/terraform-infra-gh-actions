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

variable "format" {
  type    = string
  default = "OpenAI"
}

variable "deployment_name" {
  type    = string
  default = "gpt-4o-mini"
}

variable "version" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Standard"
}

variable "sku_tier" {
  type    = string
  default = "Free"
}