resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.terraform_remote_state.hub.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.demo.identity[0].principal_id

  depends_on = [
    azurerm_linux_virtual_machine.demo
  ]
}