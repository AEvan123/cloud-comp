# I. Prérequis
## A. Choix de l'algorithme de chiffrement¶

### 🌞 Déterminer quel algorithme de chiffrement utiliser pour vos clés
J'utilise ed25519

#### vous n'utiliserez PAS RSA
#### donner une source fiable qui explique pourquoi on évite RSA désormais (pour les connexions SSH notamment)
https://devblogs.microsoft.com/devops/ssh-rsa-deprecation/#:~:text=The%20SSH%2DRSA%20is%20a,connect%20to%20repos%20through%20SSH.

#### donner une source fiable qui recommande un autre algorithme de chiffrement (pour les connexions SSH notamment)
https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025#:~:text=The%20ed25519%20algorithm%20is%20based,with%20the%20ssh%2Dkeygen%20command.

## B. Génération de votre paire de clés¶
### 🌞 Générer une paire de clés pour ce TP

#### la clé privée doit s'appeler cloud_tp1
#### elle doit se situer dans le dossier standard pour votre utilisateur
#### elle doit utiliser l'algorithme que vous avez choisi à l'étape précédente (donc, pas de RSA)
#### elle est protégée par un mot de passe de votre choix
```
C:\WINDOWS\system32> ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\username/.ssh/id_ed25519): C:\Users\username/.ssh/cloud_tp1
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\username/.ssh/cloud_tp1
Your public key has been saved in C:\Users\username/.ssh/cloud_tp1.pub
```

## C. Agent SSH

### 🌞 Configurer un agent SSH sur votre poste

#### détaillez-moi toute la conf ici que vous aurez fait

vérifier si j’ai ssh-agent et voir son statut : 
```
C:\WINDOWS\system32> Get-Service ssh-agent

ce qui renvoie

Status   Name               DisplayName
------   ----               -----------
Stopped  ssh-agent          OpenSSH Authentication Agent

Lancer le service : 
C:\WINDOWS\system32> Start-Service ssh-agent
C:\WINDOWS\system32> ssh-agent

C:\WINDOWS\system32> ssh-add C:\Users\username/.ssh/cloud_tp1
Enter passphrase for C:\Users\username/.ssh/cloud_tp1:
Identity added: C:\Users\username/.ssh/cloud_tp1 (username@machine)
```

# II. Spawn des VMs

## 1. Depuis la WebUI

### 🌞 Connectez-vous en SSH à la VM pour preuve

#### cette connexion ne doit demander aucun password : votre clé a été ajoutée à votre Agent SSH

```
C:\Users\username> ssh azureuser@<IP de la VM azure>

azureuser@az104:~$
```

## 2. az : a programmatic approach¶
### 🌞 Créez une VM depuis le Azure CLI

#### en utilisant uniquement la commande `az` donc je vous laisse faire vos recherches pour créer une VM avec la commande az vous devrez préciser :

#### quel utilisateur doit être créé à la création de la VM le fichier de clé utilisé pour se connecter à cet utilisateur comme ça, dès que la VM pop, on peut se co en SSH !
```
PS /home/user> az vm create --resource-group tp1 --name MyVM2 --image Debian11 --size Standard_B1s --admin-username azureuser --authentication-type ssh --ssh-key-type Ed25519 --ssh-key-values <Clé_SSH.pub>

The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.

{
  "fqdns": "",
  "id": "/subscriptions/<sub_id>/resourceGroups/tp1/providers/Microsoft.Compute/virtualMachines/MyVM2",
  "location": "uksouth",
  "macAddress": <add_mac_vm>,
  "powerState": "VM running",
  "privateIpAddress": <ip privée>,
  "publicIpAddress": <ip publique>,
  "resourceGroup": "tp1"
}
```

### 🌞 Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique

#### une commande SSH fonctionnelle vers la VM sans password toujouuurs because Agent SSH Warning
```
PS C:\Users\username> ssh azureuser@<ip publique de la vm>
Linux MyVM2 6.1.0-0.deb11.35-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.137-1~deb11u1 x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
azureuser@MyVM2:~$
```

### 🌞 Une fois connecté, prouvez la présence...

#### ...du service walinuxagent.service
```
azureuser@MyVM2:~$ systemctl status walinuxagent.service
● walinuxagent.service - Microsft Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2025-09-05 12:21:56 UTC; 8min ago
   Main PID: 764 (waagent)
      Tasks: 4 (limit: 1002)
     Memory: 31.4M
        CPU: 2.976s
     CGroup: /system.slice/walinuxagent.service
             ├─764 /usr/bin/python3 /usr/sbin/waagent -daemon
             └─923 python3 -u /usr/sbin/waagent -run-exthandlers
```

#### ...du service cloud-init.service
```
azureuser@MyVM2:~$ systemctl status cloud-init.service
● cloud-init.service - Initial cloud-init job (metadata service crawler)
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     Active: active (exited) since Fri 2025-09-05 12:21:53 UTC; 8min ago
   Main PID: 597 (code=exited, status=0/SUCCESS)
      Tasks: 0 (limit: 1002)
     Memory: 0B
        CPU: 0
     CGroup: /system.slice/cloud-init.service
Sep 05 12:21:53 MyVM2 systemd[1]: Finished Initial cloud-init job (metadata service crawler).
```

## 3. Terraforming planets infrastructures

### 🌞 Utilisez Terraform pour créer une VM dans Azure

#### j'veux la suite de commande terraform utilisée dans le compte-rendu
```
PS C:\testrraform> terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/azurerm...
- Installing hashicorp/azurerm v4.43.0...
- Installed hashicorp/azurerm v4.43.0 (signed by HashiCorp)

Terraform has been successfully initialized!

PS C:\testrraform> terraform plan  
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.
```
```
PS C:\testrraform> terraform apply         
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/<sub_id>/resourceGroups/tp2]                                                                                                                    azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
Plan: 6 to add, 0 to change, 0 to destroy.
Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
Enter a value: yes
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Still creating... [00m10s elapsed]
azurerm_resource_group.main: Creation complete after 11s [id=/subscriptions/<sub_id>/resourceGroups/tp2]
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Creation complete after 6s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Creating...
azurerm_subnet.main: Creation complete after 5s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Creation complete after 3s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_linux_virtual_machine.main: Creating...
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 17s [id=/subscriptions/<sub_id>/resourceGroups/tp2/providers/Microsoft.Compute/virtualMachines/super-vm]
Apply complete! Resources: 6 added, 0 changed, 0 destroyed. 
```

### 🌞 Prouvez avec une connexion SSH sur l'IP publique que la VM est up

#### toujours pas de password avec votre Agent SSH normalement 🐈
#### si la connexion échoue, ajouter l'ouverture de port depuis la WebUI (exceptionnellement)
```
PS C:\Users\username> ssh azureuser@<ip publique vm>
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)
azureuser@super-vm:~$
```
