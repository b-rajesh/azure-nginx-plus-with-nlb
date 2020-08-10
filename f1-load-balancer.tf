
resource "azurerm_lb" "internal-load-balancer" {
  name                = "${random_pet.pet-prefix.id}-internal-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name

  frontend_ip_configuration {
    name                          = "InternalIPAddress"
    subnet_id                     = azurerm_subnet.microservice-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_rule" "f1-lb-rules" {
  resource_group_name            = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id                = azurerm_lb.internal-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-f1-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = "3000"
  backend_port                   = "3000"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.f1-lb-backend-address-pool.id
  frontend_ip_configuration_name = "InternalIPAddress"
  probe_id                       = azurerm_lb_probe.f1-microservice-probe.id
}

resource "azurerm_lb_probe" "f1-microservice-probe" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.internal-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-f1-port-3000-probe"
  protocol            = "Http"
  port                = "3000"
  request_path        = "/f1-api/health"
  number_of_probes    = "5"
}

resource "azurerm_lb_backend_address_pool" "f1-lb-backend-address-pool" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.internal-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-f1-lb-backend-pool"
}
