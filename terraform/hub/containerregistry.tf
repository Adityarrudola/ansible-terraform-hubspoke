resource "azurerm_container_registry" "demo" {
  name                = "${var.env}rudcontainerregistry"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.demo.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.demo.identity[0].principal_id
}