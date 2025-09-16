# network.tf

resource "azurerm_network_security_group" "main" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ip_address
    destination_address_prefix = "*"
    description                = "Acces SSH"
  }
}

# associer le nsg a la vm

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id        = azurerm_network_interface.main.id
  network_security_group_id   = azurerm_network_security_group.main.id
}
