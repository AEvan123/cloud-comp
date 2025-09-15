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
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://storage.azure.com/"
```
### 🌞 Expliquez comment l'IP 169.254.169.254 peut être joignable
