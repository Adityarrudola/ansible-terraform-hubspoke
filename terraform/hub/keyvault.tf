resource "azurerm_key_vault" "demo" {
  name                = "${var.env}-rudola-kv"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  tenant_id           = data.azurerm_client_config.demo.tenant_id

  sku_name = "standard"
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "jenkins_policy" {

  key_vault_id = azurerm_key_vault.demo.id
  tenant_id    = data.azurerm_client_config.demo.tenant_id
  object_id    = data.azurerm_client_config.demo.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_secret" "sql_username" {
  name         = "sql-username"
  value        = random_string.sql_username.result
  key_vault_id = azurerm_key_vault.demo.id

  depends_on = [
    azurerm_key_vault_access_policy.jenkins_policy
  ]
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-password"
  value        = random_password.sql_password.result
  key_vault_id = azurerm_key_vault.demo.id

  depends_on = [
    azurerm_key_vault_access_policy.jenkins_policy
  ]
}