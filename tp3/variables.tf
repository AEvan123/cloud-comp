variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "ip_address" {
  type        = string
  description = "Azure subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "public_key_path" {
  type        = string
  description = "Path to your SSH public key"
}

variable "domain_name_label" {
  type        = string
  description = "nom de DNS"
}

variable "alert_email_address" {
  type        = string
  description = "Le mail qui reçoit l'alerte"
}

variable "cert_kv_name" {
  type        = string
  description = "Le nom key vault du certificat"
}

variable "key_vault_name" {
  type        = string
  description = "Le nom key vault"
}

variable "root_pass" {
  type        = string
  description = "Mdp root de la BDD"
}

variable "db_pass" {
  type        = string
  description = "Mdp BDD de l'utilisateur nextcloud"
}

variable "db_user" {
  type        = string
  description = "nom de l'utilisateur nextcloud"
}