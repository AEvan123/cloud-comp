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
azureuser@super-vm:~$ az graph query -q "
alertsmanagementresources | project name"
{
  "count": 1,
  "data": [
    {
      "name": "cpu-alert-super-vm"
    }
  ],
  "skip_token": null,
  "total_records": 1
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
#!/usr/bin/env bash
set -euo pipefail

# === À RENSEIGNER ===
KEYVAULT_NAME="<nom_keyvault>"        # sans le .vault.azure.net
SECRET_NAME="<nom_secret>"      # nom du secret
SECRET_VERSION=""             # optionnel, sinon dernière version
USER_ASSIGNED_CLIENT_ID=""    # optionnel: clientId d'une identity managée "user-assigned"

# === Constantes ===
IMDS="http://169.254.169.254/metadata/identity/oauth2/token"
IMDS_API="2018-02-01"
KV_RESOURCE_ENC="https%3A%2F%2Fvault.azure.net"
KV_API="7.4"

# 1) Récupérer un jeton AAD pour Key Vault via l'IMDS (Managed Identity)
CLIENT_PARAM=""
if [[ -n "$USER_ASSIGNED_CLIENT_ID" ]]; then
  CLIENT_PARAM="&client_id=${USER_ASSIGNED_CLIENT_ID}"
fi

ACCESS_TOKEN="$(
  curl -sS -H "Metadata:true" \
    "${IMDS}?api-version=${IMDS_API}&resource=${KV_RESOURCE_ENC}${CLIENT_PARAM}" \
  | jq -r '.access_token'
)"

# 2) Appeler l'API Secrets de Key Vault
BASE_URL="https://${KEYVAULT_NAME}.vault.azure.net/secrets/${SECRET_NAME}"
if [[ -n "$SECRET_VERSION" ]]; then
  BASE_URL="${BASE_URL}/${SECRET_VERSION}"
fi

# On récupère la réponse et le code HTTP proprement
TMP_JSON="$(mktemp)"
HTTP_CODE="$(
  curl -sS -o "${TMP_JSON}" -w "%{http_code}" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    "${BASE_URL}?api-version=${KV_API}"
)"

if [[ "${HTTP_CODE}" != "200" ]]; then
  echo "Erreur Key Vault (HTTP ${HTTP_CODE}):"
  cat "${TMP_JSON}" 1>&2
  exit 1
fi

# 3) Afficher uniquement la valeur du secret
jq -r '.value' "${TMP_JSON}"
rm -f "${TMP_JSON}"
```
