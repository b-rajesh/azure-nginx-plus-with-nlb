resource "azurerm_linux_virtual_machine_scale_set" "ngplus-api-gwy-scale-set" {
  name                            = "${random_pet.pet-prefix.id}-nginx-plus-edge-proxy"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.nginx-plus-gateway-resourcegroup.name
  upgrade_mode                    = "Manual"
  sku                             = "Standard_F2" //Standard_DS1_v2
  instances                       = 1
  admin_username                  = var.admin_user
  //admin_password                  = ""
  //disable_password_authentication = false
  /*
  admin_ssh_key {
    username   = var.admin_user
    public_key = file("~/.ssh/id_rsa_azure.pub")
  }
*/
  computer_name_prefix = "nginx-plus-gwy"
  source_image_id      = data.azurerm_image.nginx-plus-r22-image.id
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 50
  }
  /*
 data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
   storage_account_type = "Standard_LRS"
 }
*/
  network_interface {
    name    = "${random_pet.pet-prefix.id}-network-profile"
    primary = true

    ip_configuration {
      name                                   = "${random_pet.pet-prefix.id}-ip-config"
      subnet_id                              = azurerm_subnet.gateway-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend-address-pool.id]
      primary                                = true
    }
  }
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

data "azurerm_resource_group" "nginxplus-image-rg" {
  name = var.nginx-plus-resource-group
}

data "azurerm_image" "nginx-plus-r22-image" {
  name                = var.nginx-plus-image-name
  resource_group_name = data.azurerm_resource_group.nginxplus-image-rg.name
}

resource "azurerm_network_security_group" "vm-scale-set-nsg" {
    name                = "${random_pet.pet-prefix.id}-gwy-vm-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.nginx-plus-gateway-resourcegroup.name
    
    security_rule {
        name                       = "LB-Access"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = var.public-subnet-cidr
        source_port_range          = "*"
        destination_port_ranges     = ["8080","80","443"]
    }

    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}

