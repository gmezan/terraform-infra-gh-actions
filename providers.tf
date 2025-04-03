terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "gmezan-terraform-infra-gh-actions"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}