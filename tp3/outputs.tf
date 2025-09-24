# outputs.tf

# DNS
output "dns_name" {
    description = "nom de DNS"
    value       = azurerm_public_ip.vm_pip1.fqdn
}

# DNS
output "username" {
    description = "nom d'utilisateur DB"
    value       = var.db_user

}
