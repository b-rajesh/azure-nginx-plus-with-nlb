resource "azurerm_lb" "internal-load-balancer" {
  name                = "${random_pet.pet-prefix.id}-internal-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.microservice-resourcegroup.name

  frontend_ip_configuration {
    name                 = "InternalIPAddress"
    subnet_id            = azurerm_subnet.microservice-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}