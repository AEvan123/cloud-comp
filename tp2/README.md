# I. Network Security Group
### 🌞 Prouver que ça fonctionne, rendu attendu :

#### la sortie du terraform apply
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.main will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_username                                         = "azureuser"
      + allow_extension_operations                             = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "uksouth"
      + max_bid_price                                          = -1
      + name                                                   = "super-vm"
      + network_interface_ids                                  = (known after apply)
      + os_managed_disk_id                                     = (known after apply)
      + patch_assessment_mode                                  = (known after apply)
      + patch_mode                                             = (known after apply)
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = (known after apply)
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "tp2"
      + size                                                   = "Standard_B1s"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                <ssh_key>
            EOT
          + username   = "azureuser"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = "vm-os-disk"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-focal"
          + publisher = "Canonical"
          + sku       = "20_04-lts"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "uksouth"
      + mac_address                    = (known after apply)
      + name                           = "vm-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "tp2"
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_security_group_association.main will be created
  + resource "azurerm_network_interface_security_group_association" "main" {
      + id                        = (known after apply)
      + network_interface_id      = (known after apply)
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "vm-nsg"
      + resource_group_name = "tp2"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = "Acces SSH"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "SSH"
              + priority                                   = 300
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "<machine.ip>"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "uksouth"
      + name                    = "vm-ip"
      + resource_group_name     = "tp2"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "tp2"
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefixes                              = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "vm-subnet"
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "tp2"
      + virtual_network_name                          = "vm-vnet"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space                  = [
          + "10.0.0.0/16",
        ]
      + dns_servers                    = (known after apply)
      + guid                           = (known after apply)
      + id                             = (known after apply)
      + location                       = "uksouth"
      + name                           = "vm-vnet"
      + private_endpoint_vnet_policies = "Disabled"
      + resource_group_name            = "tp2"
      + subnet                         = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Still creating... [00m10s elapsed]
azurerm_resource_group.main: Creation complete after 11s [id=/subscriptions/<sub_id>/resourceGroups/tp2]
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_network_security_group.main: Creating...
azurerm_network_security_group.main: Creation complete after 2s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Creation complete after 5s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Creating...
azurerm_subnet.main: Creation complete after 5s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.main: Creating...
azurerm_linux_virtual_machine.main: Creating...
azurerm_network_interface_security_group_association.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 16s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Compute/virtualMachines/super-vm]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```
#### une commande az pour obtenir toutes les infos liées à la VM
```
azureuser@super-vm:~$ az network nsg list
```

#### une commande ssh fonctionnelle
```
C:\>ssh azureuser@<vm_ip>
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System load:  0.0               Processes:             110
  Usage of /:   5.5% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: 2025 from <machine.ip>
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@super-vm:~$
```
#### changement de port :
modifiez le port d'écoute du serveur OpenSSH sur la VM pour le port 2222/tcp
prouvez que le serveur OpenSSH écoute sur ce nouveau port (avec une commande ss sur la VM)
prouvez qu'une nouvelle connexion sur ce port 2222/tcp ne fonctionne pas à cause du NSG

```
azureuser@super-vm:~$ sudo ufw allow 2222/tcp
Rules updated
Rules updated (v6)
azureuser@super-vm:~$ sudo nano /etc/ssh/sshd_config
azureuser@super-vm:~$ sudo sshd -t
azureuser@super-vm:~$ sudo systemctl reload sshd
azureuser@super-vm:~$ sudo ss -ltnp | grep ':2222'
LISTEN    0         128                0.0.0.0:2222             0.0.0.0:*        users:(("sshd",pid=871,fd=3))          
LISTEN    0         128                   [::]:2222                [::]:*        users:(("sshd",pid=871,fd=4))          
azureuser@super-vm:~$ sudo ss -ltnp | grep ':22'
LISTEN    0         128                0.0.0.0:2222             0.0.0.0:*        users:(("sshd",pid=871,fd=3))          
LISTEN    0         128                   [::]:2222                [::]:*        users:(("sshd",pid=871,fd=4))          
azureuser@super-vm:~$ exit
logout
Connection to <vm_ip> closed.

C:\>ssh azureuser@<vm_ip> -p 22
ssh: connect to host <vm_ip> port 22: Connection refused

C:\>ssh azureuser@<vm_ip> -p 2222
ssh: connect to host <vm_ip> port 2222: Connection timed out

C:\>
```

# II. Un ptit nom DNS

### 🌞 Proofs ! Donnez moi :

#### la sortie du terraform apply (ce qu'affiche votre outputs.tf)
```
PS C:\testrraform> terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.main will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_username                                         = "azureuser"
      + allow_extension_operations                             = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "uksouth"
      + max_bid_price                                          = -1
      + name                                                   = "super-vm"
      + network_interface_ids                                  = (known after apply)
      + os_managed_disk_id                                     = (known after apply)
      + patch_assessment_mode                                  = (known after apply)
      + patch_mode                                             = (known after apply)
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = (known after apply)
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "tp2"
      + size                                                   = "Standard_D2s_v3"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                <ssh_key>
            EOT
          + username   = "azureuser"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = "vm-os-disk"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-focal"
          + publisher = "Canonical"
          + sku       = "20_04-lts"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "uksouth"
      + mac_address                    = (known after apply)
      + name                           = "vm-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "tp2"
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_security_group_association.main will be created
  + resource "azurerm_network_interface_security_group_association" "main" {
      + id                        = (known after apply)
      + network_interface_id      = (known after apply)
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "vm-nsg"
      + resource_group_name = "tp2"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = "Acces SSH"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "SSH"
              + priority                                   = 300
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "<machine.ip>"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + domain_name_label       = "testtp2"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "uksouth"
      + name                    = "vm-ip"
      + resource_group_name     = "tp2"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "tp2"
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefixes                              = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "vm-subnet"
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "tp2"
      + virtual_network_name                          = "vm-vnet"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space                  = [
          + "10.0.0.0/16",
        ]
      + dns_servers                    = (known after apply)
      + guid                           = (known after apply)
      + id                             = (known after apply)
      + location                       = "uksouth"
      + name                           = "vm-vnet"
      + private_endpoint_vnet_policies = "Disabled"
      + resource_group_name            = "tp2"
      + subnet                         = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 10s [id=/subscriptions/<sub_id>/resourceGroups/tp2]
azurerm_virtual_network.main: Creating...
azurerm_network_security_group.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_network_security_group.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_virtual_network.main: Creation complete after 5s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Creating...
azurerm_public_ip.main: Creation complete after 7s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_subnet.main: Creation complete after 4s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.main: Creating...
azurerm_linux_virtual_machine.main: Creating...
azurerm_network_interface_security_group_association.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkSecurityGroups/vm-nsg]
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 12s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Compute/virtualMachines/super-vm]
```
#### une commande ssh fonctionnelle vers le nom de domaine (pas l'IP)
```
C:\Windows\System32>ssh azureuser@testtp2.uksouth.cloudapp.azure.com
azureuser@super-vm:~$
```

### 🌞 Un ptit output nan ?
```
# outputs.tf

# adresse IP
output "public_ip" {
    description = "Public IPv4 of the VM"
    value       = azurerm_public_ip.main.ip_address
}

# DNS
output "dns_name" {
    description = "nom de DNS"
    value       = azurerm_public_ip.main.fqdn
}
```

# III. Blob storage

### 🌞 Compléter votre plan Terraform pour déployer du Blob Storage pour votre VM

### 🌞 Prouvez que tout est bien configuré, depuis la VM Azure

#### installez azcopy dans la VM (suivez la doc officielle pour l'installer dans votre VM Azure)
```
curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb

sudo dpkg -i packages-microsoft-prod.deb

rm packages-microsoft-prod.deb

sudo apt-get update

sudo apt-get install azcopy
```

#### azcopy login --identity pour vous authentifier automatiquement
#### utilisez azcopy pour écrire un fichier dans le Storage Container que vous avez créé
```
azcopy copy test.txt https://<nom_compte>.blob.core.windows.net/<nom_container>
```
#### utilisez azcopy pour lire le fichier que vous venez de push
```
azcopy copy https://<nom_compte>.blob.core.windows.net/<nom_container>/test.txt "tel/"
```

### 🌞 Déterminez comment azcopy login --identity vous a authentifié

azcopy appelles l'IMDS qui a pour audiance 169.254.169.254 pour avoir un OAuth token, puis azcopy le stock dans son cache .azcopy puis l'envoies au storage aux niveau des autorisations.
Azure storage vérifie ensuite le token et l'audience.

### 🌞 Requêtez un JWT d'authentification auprès du service que vous venez d'identifier, manuellement

#### depuis la VM
#### avec une commande curl
#### à priori ce sera une requête vers 169.254.169.254
```
curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://storage.azure.com/" | jq -r ".access_token"
```
### 🌞 Expliquez comment l'IP 169.254.169.254 peut être joignable

169.254.169.254 est l'adresse de l'IMDS d'Azure.
Cette route vers cette adresse est faite lors du démarrage de la machine lorsqu'elle a une adresse ip via DHCP

# IV. Monitoring

### 🌞 Une commande az qui permet de lister les alertes actuellement configurées
```
azureuser@super-vm:~$ az monitor metrics alert list
[
  {
    "actions": [
      {
        "actionGroupId": "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Insights/actionGroups/ag-tp2-alerts",
        "webHookProperties": {}
      }
    ],
    "autoMitigate": true,
    "criteria": {
      "allOf": [
        {
          "criterionType": "StaticThresholdCriterion",
          "metricName": "Percentage CPU",
          "metricNamespace": "Microsoft.Compute/virtualMachines",
          "name": "Metric1",
          "operator": "GreaterThan",
          "skipMetricValidation": false,
          "threshold": 70.0,
          "timeAggregation": "Average"
        }
      ],
      "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
    },
    "description": "Alert when CPU usage exceeds 70%",
    "enabled": true,
    "evaluationFrequency": "PT1M",
    "id": "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Insights/metricAlerts/cpu-alert-super-vm",
    "location": "global",
    "name": "cpu-alert-super-vm",
    "resourceGroup": "tp2",
    "scopes": [
      "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Compute/virtualMachines/super-vm"
    ],
    "severity": 2,
    "tags": {},
    "targetResourceRegion": "",
    "targetResourceType": "",
    "type": "Microsoft.Insights/metricAlerts",
    "windowSize": "PT5M"
  },
  {
    "actions": [
      {
        "actionGroupId": "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Insights/actionGroups/ag-tp2-alerts",
        "webHookProperties": {}
      }
    ],
    "autoMitigate": true,
    "criteria": {
      "allOf": [
        {
          "criterionType": "StaticThresholdCriterion",
          "metricName": "Available Memory Bytes",
          "metricNamespace": "Microsoft.Compute/virtualMachines",
          "name": "Metric1",
          "operator": "LessThan",
          "skipMetricValidation": false,
          "threshold": 512000000.0,
          "timeAggregation": "Average"
        }
      ],
      "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
    },
    "description": "Less than 512Mo available",
    "enabled": true,
    "evaluationFrequency": "PT1M",
    "id": "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Insights/metricAlerts/ram-alert-super-vm",
    "location": "global",
    "name": "ram-alert-super-vm",
    "resourceGroup": "tp2",
    "scopes": [
      "/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Compute/virtualMachines/super-vm"
    ],
    "severity": 2,
    "tags": {},
    "targetResourceRegion": "",
    "targetResourceType": "",
    "type": "Microsoft.Insights/metricAlerts",
    "windowSize": "PT5M"
  }
]
```
### 🌞 Stress de la machine

#### installez le paquet stress-ng dans la VM
#### utilisez la commande stress-ng pour :

#### stress le CPU (donner la commande)
```
azureuser@super-vm:~$ stress-ng --cpu 2 --cpu-method all --metrics-brief -t 10m
```
#### stress la RAM (donner la commande)
```
stress-ng --vm 1 --vm-bytes 75% --vm-keep --metrics-brief -t 10m
```

### 🌞 Vérifier que des alertes ont été fired

#### dans le compte-rendu, je veux une commande az qui montre que les alertes ont été levées
```
azureuser@super-vm:~$ az graph query -q "alertsmanagementresources | project name"
{
  "count": 2,
  "data": [
    {
      "name": "cpu-alert-super-vm"
    },
    {
      "name": "ram-alert-super-vm"
    }
  ],
  "skip_token": null,
  "total_records": 2
}
```
# V. Azure Vault

```
azureuser@super-vm:~$ az keyvault secret show --name "<Le nom de ton secret ici>" --vault-name "<Le nom de ta Azure Key Vault ici>" | grep "value"
  "value": ")Hr5decYHuhuie5P"
```

### 🌞 Depuis la VM, afficher le secret

#### il faut donc faire une requête à la Azure Key Vault depuis la VM Azure
#### un ptit script shell ça le fait !
```
#!/bin/bash
# variables
keyvault_name="<nom_keyvault>"
vault_name="<nom_vault>"

#
secret_url="https://${keyvault_name}.vault.azure.net/secrets/${vault_name}?api-version=7.4'"

token="$(curl -sS -H Metadata:true \
'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' \
| jq -r '.access_token')"

secret="$(curl -sS -H "Authorization: Bearer ${token}" \
"https://${keyvault_name}.vault.azure.net/secrets/${vault_name}?api-version=7.4" | jq -r '.value')"

echo $secret
exit 0
```
