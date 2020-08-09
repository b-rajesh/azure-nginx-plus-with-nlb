provider "azurerm" {
  version = "~>2.20.0"
  features {}
}

resource "random_pet" "pet-prefix" {
  length = 1
  prefix = var.prefix
}

