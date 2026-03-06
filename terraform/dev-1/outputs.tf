output "dev1_vnet_id" {
  value = azurerm_virtual_network.demo.id
}

output "dev1_vnet_name" {
  value = azurerm_virtual_network.demo.name
}

output "dev1_rg_name" {
  value = azurerm_resource_group.demo.name
}