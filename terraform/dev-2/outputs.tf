output "dev2_vnet_id" {
  value = azurerm_virtual_network.demo.id
}

output "dev2_vnet_name" {
  value = azurerm_virtual_network.demo.name
}

output "dev2_rg_name" {
  value = azurerm_resource_group.demo.name
}

output "dev2_public_ip" {
  value = azurerm_public_ip.demo.ip_address
}

output "dev2_vm_identity" {
  value = azurerm_linux_virtual_machine.demo.identity[0].principal_id
}