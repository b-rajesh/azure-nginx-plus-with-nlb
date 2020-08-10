resource "azurerm_linux_virtual_machine_scale_set" "hello-f1-scale-set" {
  name                            = "${random_pet.pet-prefix.id}-f1-microservice-vmss"
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
  computer_name_prefix = "F1-Microservice"
  source_image_id      = data.azurerm_image.f1-image.id
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
    name    = "${random_pet.pet-prefix.id}-f1-network-profile"
    primary = true

    ip_configuration {
      name                                   = "${random_pet.pet-prefix.id}-f1-ip-config"
      subnet_id                              = azurerm_subnet.microservice-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.f1-lb-backend-address-pool.id]
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

data "azurerm_resource_group" "f1-image-rg" {
  name = var.f1-image-resource-group
}

data "azurerm_image" "f1-image" {
  name                = var.f1-image-name
  resource_group_name = data.azurerm_resource_group.f1-image-rg.name
}

resource "azurerm_virtual_machine_scale_set_extension" "vm-scale-set-init-script" {
  name                         = "${random_pet.pet-prefix.id}-vmss-init"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.hello-f1-scale-set.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  settings = jsonencode({
    "commandToExecute" = "npm start --prefix /usr/src/app/ "
  })
}

resource "null_resource" "f1-api-upstream" {
  depends_on  = [azurerm_virtual_machine_scale_set_extension.vm-scale-set-init-script, azurerm_lb.internal-load-balancer, azurerm_public_ip.loadbalancer-public-ip]
  provisioner "local-exec" {
    command = "curl -X POST -d '{\"server\": \"${azurerm_lb.internal-load-balancer.private_ip_address}:3000\"}' -s  'http://${azurerm_public_ip.loadbalancer-public-ip.fqdn}:8080/api/6/http/upstreams/f1_api/servers'"
  }
}


resource "azurerm_network_security_group" "f1-ms-nsg" {
    depends_on = [azurerm_lb.internal-load-balancer]
    name                = "${random_pet.pet-prefix.id}-f1-ms-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.microservice-resourcegroup.name
    
    security_rule {
        name                       = "F1-MS-Access"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        //source_address_prefix      = "AzureLoadBalancer"
        source_address_prefixes    = [azurerm_lb.internal-load-balancer.private_ip_address]
        destination_address_prefix = var.private-subnet-cidr
        source_port_range          = "*"
        destination_port_ranges    = ["22","3000","3600"]
    }
    security_rule {
      name                       = "F1-MS-Outbound-Access"
      priority                   = 104
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
