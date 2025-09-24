# main.tf

provider "azurerm" {
  subscription_id = var.subscription_id
    features {
    key_vault {
      purge_soft_deleted_certificates_on_destroy = true
      recover_soft_deleted_certificates          = true
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}