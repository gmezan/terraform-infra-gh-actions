variable "rg_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Free"
}

variable "rbac_enabled" {
  type    = bool
  default = false
}

variable "auto_scaling" {
  type    = bool
  default = false
}

variable "oidc_issuer_enabled" {
  type    = bool
  default = false
}

variable "workload_identity_enabled" {
  type    = bool
  default = false
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "node_min_count" {
  type    = number
  default = 1
}

variable "node_max_count" {
  type    = number
  default = 2
}