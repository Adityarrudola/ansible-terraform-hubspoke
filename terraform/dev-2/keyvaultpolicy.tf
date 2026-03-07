resource "azurerm_key_vault_access_policy" "dev2_vm_policy" {
  key_vault_id = azurerm_key_vault.demo.id
  tenant_id    = data.azurerm_client_config.demo.tenant_id
  object_id    = data.terraform_remote_state.dev2.outputs.dev2_vm_identity

  secret_permissions = [
    "Get",
    "List"
  ]
}