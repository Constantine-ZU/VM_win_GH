#access key in yaml
terraform {
    backend "azurerm" {
    storage_account_name = "constantine2zu"
    container_name       = "tf4config"
    key                  = "terraform3.tfstate"

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}



provider "azurerm" {
  features {}
}

# rg-srv-win for Windows Srv 2022
resource "azurerm_resource_group" "rg-srv-win" {
  name     = "rg-win-srv"
 location  = "northeurope"
}

#for ubuntu, PG and LB
resource "azurerm_resource_group" "rg-azweb" {
  name     = "azweb-resources"
  location = "northeurope"
}