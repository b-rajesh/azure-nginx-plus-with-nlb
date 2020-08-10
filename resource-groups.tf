# Resource group for network resources
resource "azurerm_resource_group" "vnet-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-vnet-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_resource_group" "external-loadbalancer-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-external-lb-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_resource_group" "internal-loadbalancer-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-internal-lb-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}


resource "azurerm_resource_group" "nginx-plus-gateway-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-ngplus-gwy-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_resource_group" "microservice-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-microservice-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

