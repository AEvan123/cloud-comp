# outputs.tf

# DNS
output "dns_name" {
    description = "nom de DNS"
    value       = azurerm_public_ip.main.fqdn
}

# DNS
output "username" {
    description = "nom d'utilisateur DB"
    value       = var.db_user
}