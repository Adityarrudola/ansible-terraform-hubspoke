data "azurerm_client_config" "demo" {}

resource "azurerm_key_vault_access_policy" "dev2_vm_policy" {

  key_vault_id = data.terraform_remote_state.hub.outputs.keyvault_id
  tenant_id    = data.azurerm_client_config.demo.tenant_id
  object_id    = azurerm_linux_virtual_machine.demo.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

}