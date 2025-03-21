terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "rg-infra-state"
    storage_account_name = "gmezanterraformghactions"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }

  backend "s3" {
    bucket = "gmezan-terraform-infra-gh-actions"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}