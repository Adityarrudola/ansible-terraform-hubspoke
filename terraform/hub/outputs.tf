output "hub_vnet_id" {
  value = azurerm_virtual_network.demo.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.demo.name
}

output "hub_rg_name" {
  value = azurerm_resource_group.demo.name
}