
resource "azurerm_lb" "hello-int-load-balancer" {
  name                            = "${random_pet.pet-prefix.id}-hello-nplus-int-lb"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.internal-loadbalancer-resourcegroup.name

  frontend_ip_configuration {
    name                          = "HNInternalIPAddress"
    subnet_id                     = azurerm_subnet.microservice-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_rule" "hello-nplus-lb-rules" {
  resource_group_name            = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id                = azurerm_lb.hello-int-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-hello-nplus-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = "3000"
  backend_port                   = "3000"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.hello-lb-backend-address-pool.id
  frontend_ip_configuration_name = "HNInternalIPAddress"
  probe_id                       = azurerm_lb_probe.hello-microservice-probe.id
}

resource "azurerm_lb_probe" "hello-microservice-probe" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.hello-int-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-hello-port-3000-probe"
  protocol            = "Http"
  port                = "3000"
  request_path        = "/hello-nginxplus-api"
  number_of_probes    = "5"
}

resource "azurerm_lb_backend_address_pool" "hello-lb-backend-address-pool" {
  resource_group_name = azurerm_resource_group.internal-loadbalancer-resourcegroup.name
  loadbalancer_id     = azurerm_lb.hello-int-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-hello-lb-backend-pool"
}
