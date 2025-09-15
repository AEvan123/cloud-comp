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

