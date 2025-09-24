resource "azurerm_virtual_network" "main" {
  name                = "vm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

###################################### Network VM1

resource "azurerm_network_interface" "vm_nic1" {
  name                = "vm-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                            = "internal1"
    subnet_id                       = azurerm_subnet.main.id
    private_ip_address_allocation   = "Static"
    private_ip_address              = "10.0.1.4"
    public_ip_address_id            = azurerm_public_ip.vm_pip1.id
  }
}

resource "azurerm_public_ip" "vm_pip1" {
  name                = "vm-pip1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  # le dns 
  domain_name_label   = var.domain_name_label
}

# nsg vm1 

resource "azurerm_network_security_group" "vm_nsg1" {
  name                = "vm-nsg1"
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

  # HTTP
  security_rule {
    name                       = "HTTP"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.ip_address
    destination_address_prefix = "*"
    description                = "Utilisation HTTP"
  }

  # HTTPS
  security_rule {
    name                       = "HTTPS"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.ip_address
    destination_address_prefix = "*"
    description                = "Utilisation HTTPS"
  }

  # MySQL
  security_rule {
    name                       = "MySQL"
    priority                   = 330
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = var.ip_address
    destination_address_prefix = "*"
    description                = "Utilisation MySQL"
  }
}

resource "azurerm_network_interface_security_group_association" "vm1" {
  network_interface_id        = azurerm_network_interface.vm_nic1.id
  network_security_group_id   = azurerm_network_security_group.vm_nsg1.id
}

##################################### Network VM2

resource "azurerm_network_interface" "vm_nic2" {
  name                = "vm-nic2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                            = "internal2"
    subnet_id                       = azurerm_subnet.main.id
    private_ip_address_allocation   = "Static"
    private_ip_address              = "10.0.1.5"
    public_ip_address_id            = null
  }
}

resource "azurerm_public_ip" "vm_pip2" {
  name                = "vm-pip2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# nsg vm2

resource "azurerm_network_security_group" "vm_nsg2" {
  name                = "vm-nsg2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "MYSQL"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.1.4"
    destination_port_range     = "3306"
    destination_address_prefix = "*"
    description                = "Acces MYSQL"
  }

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    source_address_prefix      = var.ip_address
    description                = "Acces SSH"
  }
}

# associer le nsg a la vm

resource "azurerm_network_interface_security_group_association" "vm2" {
  network_interface_id        = azurerm_network_interface.vm_nic2.id
  network_security_group_id   = azurerm_network_security_group.vm_nsg2.id
}
