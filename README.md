# Déploiement infra + Nextcloud (Terraform + cloud-init)
## Présentation

Ce projet déploie automatiquement, via Terraform, une infra réseau + 2 VMs (web & db) sur Azure, configure MySQL et Nginx/Nextcloud avec cloud-init, et récupère un certificat PFX depuis Azure Key Vault (via l’identité managée) pour activer TLS sur Nginx.
Objectif : obtenir une instance Nextcloud prête à l’emploi, reliée à une base MySQL accessible uniquement sur IP privée.

### Prérequis
* Terraform installé
* Accès Azure (abonnement) et ressources nécessaires (Key Vault existant ou créé par keyvault.tf)
* Les variables Terraform dans terraform.tfvars complétées avant l’apply

## Variables attendues
Les variables attendus sont dans le fichier `terraform.tfvars`

## Déploiement
Une fois les variables changée
1. Initialiser, planifier puis appliquer :
```
terraform init
terraform plan
terraform apply
```
2. Après l’`apply`, récupère l’URL d’output (exposée par `outputs.tf`).
3. Paramétrage de la base dans Nextcloud :
* Utiliser le nom d'utilisateur choisi pour l'utilisateur et le nom de la base
* Utiliser le serveur 10.0.1.5:3306 (la VM DB) au lieu de localhost.

### Détails d’automatisation (cloud-init)
* `cloud-init-db.sh` : installe MySQL, sécurise l’instance (mysql_secure_installation), crée la base et l’utilisateur `${DB_USERNAME}` autorisé depuis `${PRIVATE_IP}`, ouvre UFW pour SSH & 3306.

* `cloud-init-web.sh` : installe Nginx + PHP + Nextcloud, se connecte à Azure via Managed Identity (`az login --identity`), récupère le PFX depuis Key Vault (`${V_NAME}/${KV_NAME}`), extrait certificat et la clé, et génère le vhost Nginx pour `${NEXTCLOUD_FQDN}` (HTTP → redir vers HTTPS pour /nextcloud). Crée aussi la tâche cron Nextcloud.

