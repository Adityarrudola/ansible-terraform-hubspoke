output "hub_vnet_id" {
  value = azurerm_virtual_network.demo.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.demo.name
}

output "hub_rg_name" {
  value = azurerm_resource_group.demo.name
}

output "acr_id" {
  value = azurerm_container_registry.demo.id
}

output "keyvault_id" {
  value = azurerm_key_vault.demo.id
}