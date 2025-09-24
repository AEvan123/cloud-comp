resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "super-vm2"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.vm_nic2.id,
  ]

  custom_data = base64encode(templatefile("${path.module}/cloud-init-db.sh", {
    PRIVATE_IP = "10.0.1.4"
    DB_PASS   = var.db_pass
    ROOT_PASS = var.root_pass
    DB_USERNAME = var.db_user
  }))

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vm-os-disk2"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  
  identity {
    type = "SystemAssigned"
  }
}