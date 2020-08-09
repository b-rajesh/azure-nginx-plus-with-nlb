# Resource group for network resources
resource "azurerm_resource_group" "network-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-network-rg"
  location = var.location
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_resource_group" "network-lb-resourcegroup" {
  name     = "${random_pet.pet-prefix.id}-net-lb-rg"
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
