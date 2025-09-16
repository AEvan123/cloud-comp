# variables.tf

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

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "ip_address" {
  type        = string
  description = "adresse ip de l'appareil"
}

variable "domain_name_label" {
  type        = string
  description = "nom de DNS"
}

variable "storage_container_name" {
  type        = string
  description = "storage container nom"
}

variable "storage_account_name" {
  type        = string
  description = "storage account nom"
}

variable "alert_email_address" {
  type        = string
  description = "Le mail qui reçoit l'alerte"
}