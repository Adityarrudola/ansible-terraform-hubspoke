data "azurerm_client_config" "demo" {}

resource "azurerm_key_vault" "demo" {
  name                = "${var.env}-rudola-kv"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  tenant_id           = data.azurerm_client_config.demo.tenant_id

  sku_name = "standard"

  purge_protection_enabled = false
}

resource "azurerm_key_vault_secret" "sql_username" {
  name         = "sql-username"
  value        = random_string.sql_username.result
  key_vault_id = azurerm_key_vault.demo.id
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-password"
  value        = random_password.sql_password.result
  key_vault_id = azurerm_key_vault.demo.id
}

resource "azurerm_key_vault_access_policy" "dev2_vm_policy" {
  key_vault_id = azurerm_key_vault.demo.id
  tenant_id = data.azurerm_client_config.demo.tenant_id
  object_id = data.terraform_remote_state.dev2.outputs.dev2_vm_identity
  secret_permissions = [
    "Get",
    "List"
  ]
}
