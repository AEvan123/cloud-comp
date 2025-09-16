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

output "coffrefortsecret" {
    description = "secret vault"
    sensitive = true
    value       = azurerm_key_vault_secret.meow_secret.value
}