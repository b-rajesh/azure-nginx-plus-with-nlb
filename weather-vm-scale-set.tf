resource "azurerm_linux_virtual_machine_scale_set" "weather-scale-set" {
  name                            = "${random_pet.pet-prefix.id}-weather-microservice-vmss"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.microservice-resourcegroup.name
  upgrade_mode                    = "Manual"
  sku                             = "Standard_F2" //Standard_DS1_v2
  instances                       = 1
  admin_username                  = var.admin_user
  admin_password                  = var.admin_password
  disable_password_authentication = false
  /*
  admin_ssh_key {
    username   = var.admin_user
    public_key = file("~/.ssh/id_rsa_azure.pub")
  }
*/
  computer_name_prefix = "Weather-Microservice"
  source_image_id      = data.azurerm_image.weather-image.id
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
    name    = "${random_pet.pet-prefix.id}-weather-network-profile"
    primary = true

    ip_configuration {
      name                                   = "${random_pet.pet-prefix.id}-weather-ip-config"
      subnet_id                              = azurerm_subnet.microservice-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.weather-lb-backend-address-pool.id]
      primary                                = true
    }
  }
/*
  automatic_os_upgrade_policy {
    disable_automatic_rollback = true
    enable_automatic_os_upgrade = true
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 34
    max_unhealthy_instance_percent          = 34
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT60S"
  }

  health_probe_id                           = azurerm_lb_probe.f1-microservice-probe.id
 */
  tags = {
    Environment = "Development"
    Created_By  = var.prefix
  }
}

data "azurerm_resource_group" "weather-image-rg" {
  name = var.weather-image-resource-group
}

data "azurerm_image" "weather-image" {
  name                = var.weather-image-name
  resource_group_name = data.azurerm_resource_group.weather-image-rg.name
}

resource "azurerm_virtual_machine_scale_set_extension" "weather-vmss-init-script" {
  name                         = "${random_pet.pet-prefix.id}-weather-vmss-init"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.weather-scale-set.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  settings = jsonencode({
    "commandToExecute" = "npm start --prefix /usr/src/app/ "
  })
}

resource "null_resource" "weather-api-upstream" {
  depends_on  = [azurerm_virtual_machine_scale_set_extension.weather-vmss-init-script, azurerm_lb.weather-int-load-balancer, azurerm_public_ip.loadbalancer-public-ip]
  provisioner "local-exec" {
    command = "curl -X POST -d '{\"server\": \"${azurerm_lb.weather-int-load-balancer.private_ip_address}:3000\"}' -s  'http://${azurerm_public_ip.loadbalancer-public-ip.fqdn}:8080/api/6/http/upstreams/weather_api/servers'"
  }
}


resource "azurerm_network_security_group" "weather-ms-nsg" {
    depends_on = [azurerm_lb.weather-int-load-balancer]
    name                = "${random_pet.pet-prefix.id}-weather-ms-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.microservice-resourcegroup.name
    
    security_rule {
        name                       = "Weather-MS-Inbound-Access"
        priority                   = 107
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        //source_address_prefix      = "AzureLoadBalancer"
        source_address_prefixes    = [azurerm_lb.weather-int-load-balancer.private_ip_address]
        destination_address_prefix = var.private-subnet-cidr
        source_port_range          = "*"
        destination_port_ranges    = ["3000","3600"]
    }
    security_rule {
      name                       = "Weather-MS-Outbound-Access"
      priority                   = 108
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
    }
    tags = {
        Environment = "Development"
        Created_By = var.prefix
    }
}
