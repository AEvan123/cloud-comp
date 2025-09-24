resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "super-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.vm_nic1.id,
  ]

  custom_data = base64encode(templatefile("${path.module}/cloud-init-web.sh", {
    NEXTCLOUD_FQDN  = var.domain_name_label
    V_NAME = azurerm_key_vault.vm1.name
    KV_NAME = azurerm_key_vault_certificate.vm1.name
  }))

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vm-os-disk1"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}