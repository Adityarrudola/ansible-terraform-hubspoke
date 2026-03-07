resource "azurerm_container_registry" "demo" {
  name                = "${var.env}rudcontainerregistry"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  sku                 = "Basic"
  admin_enabled       = true
}