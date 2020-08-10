
resource "azurerm_lb" "weather-int-load-balancer" {
  name                            = "${random_pet.pet-prefix.id}-weather-nplus-int-lb"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.internal-loadbalancer-resourcegroup.name

  frontend_ip_configuration {
    name                          = "WInternalIPAddress"
    subnet_id                     = azurerm_subnet.microservice-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_rule" "weather-nplus-lb-rules" {
  resource_group_name            = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id                = azurerm_lb.weather-int-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-weather-nplus-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = "3000"
  backend_port                   = "3000"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.weather-lb-backend-address-pool.id
  frontend_ip_configuration_name = "WInternalIPAddress"
  probe_id                       = azurerm_lb_probe.weather-microservice-probe.id
}

resource "azurerm_lb_probe" "weather-microservice-probe" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.weather-int-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-weather-port-3000-probe"
  protocol            = "Http"
  port                = "3000"
  request_path        = "/weather/health"
  number_of_probes    = "5"
}

resource "azurerm_lb_backend_address_pool" "weather-lb-backend-address-pool" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.weather-int-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-weather-lb-backend-pool"
}
