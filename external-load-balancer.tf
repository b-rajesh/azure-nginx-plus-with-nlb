
resource "azurerm_public_ip" "loadbalancer-public-ip" {
  depends_on          = [azurerm_resource_group.network-lb-resourcegroup]
  name                = "${random_pet.pet-prefix.id}-pub-lb-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name
  allocation_method   = "Static"
  domain_name_label   = random_pet.pet-prefix.id
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_lb" "network-load-balancer" {
  name                = "${random_pet.pet-prefix.id}-load-balancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.loadbalancer-public-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend-address-pool" {
  resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name
  loadbalancer_id     = azurerm_lb.network-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-lb-backend-pool"
}

resource "azurerm_lb_probe" "load-balancer-probe" {
  resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name
  loadbalancer_id     = azurerm_lb.network-load-balancer.id
  name                = "${random_pet.pet-prefix.id}-lb-port80-probe"
  port                = "80"
}

resource "azurerm_lb_rule" "loadbalancer-rules" {
  resource_group_name            = azurerm_resource_group.network-lb-resourcegroup.name
  loadbalancer_id                = azurerm_lb.network-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-http-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backend-address-pool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.load-balancer-probe.id
}

resource "azurerm_lb_rule" "lb-8080-rule" {
  resource_group_name            = azurerm_resource_group.network-lb-resourcegroup.name
  loadbalancer_id                = azurerm_lb.network-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-lb-8080-rule"
  protocol                       = "Tcp"
  frontend_port                  = "8080"
  backend_port                   = "8080"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backend-address-pool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  //probe_id                       = azurerm_lb_probe.load-balancer-probe.id
}
resource "azurerm_lb_rule" "lb-443-rule" {
  resource_group_name            = azurerm_resource_group.network-lb-resourcegroup.name
  loadbalancer_id                = azurerm_lb.network-load-balancer.id
  name                           = "${random_pet.pet-prefix.id}-lb-443-rule"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backend-address-pool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  //probe_id                       = azurerm_lb_probe.load-balancer-probe.id
}

/*
resource "azurerm_network_security_group" "lb-nsg" {
    depends_on = [azurerm_resource_group.network-lb-resourcegroup]
    name                = "${random_pet.pet-prefix.id}-gwy-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name
    
    security_rule {
        name                       = "lb-ports"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges     = ["22","80"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}

resource "azurerm_network_interface" "loadbalancer-network-interface" {
    name                        = "${random_pet.pet-prefix.id}-nw-nic"
    location                    = "eastus"
    resource_group_name = azurerm_resource_group.network-lb-resourcegroup.name
    ip_configuration {
        name                          = "${random_pet.pet-prefix.id}-nic-config"
        //subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.loadbalancer-public-ip.id
    }

    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.loadbalancer-network-interface.id
    network_security_group_id = azurerm_network_security_group.lb-nsg.id
}

*/