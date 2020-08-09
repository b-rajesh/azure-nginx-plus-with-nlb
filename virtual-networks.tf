resource "azurerm_virtual_network" "virtual-network" {
  depends_on          = [azurerm_resource_group.network-resourcegroup]
  name                = "${random_pet.pet-prefix.id}-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.network-resourcegroup.name
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

resource "azurerm_subnet" "gateway-subnet" {
  depends_on           = [azurerm_resource_group.network-resourcegroup]
  name                 = "${random_pet.pet-prefix.id}-gwy-subnet"
  resource_group_name  = azurerm_resource_group.network-resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = [var.public-subnet-cidr]
}

resource "azurerm_subnet" "microservice-subnet" {
  depends_on           = [azurerm_resource_group.network-resourcegroup]
  name                 = "${random_pet.pet-prefix.id}-ms-subnet"
  resource_group_name  = azurerm_resource_group.network-resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = [var.private-subnet-cidr]
}
/*

resource "azurerm_network_security_group" "gateway-nsg" {
    depends_on = [azurerm_resource_group.network-resourcegroup]
    name                = "${random_pet.pet-prefix.id}-gwy-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.network-resourcegroup.name
    
    security_rule {
        name                       = "WEB"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges     = ["8080","80","443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}

resource "azurerm_network_interface" "gwy-subnet-interface-card" {
    depends_on = [azurerm_resource_group.network-resourcegroup]
    name                = "${random_pet.pet-prefix.id}-virtual-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.network-resourcegroup.name

    ip_configuration {
        name                          = "${random_pet.pet-prefix.id}-nic-config"
        subnet_id                     = azurerm_subnet.gateway-subnet.id
        private_ip_address_allocation = "Dynamic"
    }
    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.virtual-network-interface-card.id
    network_security_group_id = azurerm_network_security_group.gateway-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "public-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.gateway-subnet.id
  network_security_group_id = azurerm_network_security_group.gateway-nsg.id
}
*/