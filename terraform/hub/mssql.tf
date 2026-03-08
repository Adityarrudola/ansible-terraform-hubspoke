resource "azurerm_mssql_server" "demo" {
  name                         = "${var.env}-demorudola-sqlserver"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  version                      = "12.0"
  administrator_login          = random_string.sql_username.result
  administrator_login_password = random_password.sql_password.result
}

resource "azurerm_mssql_database" "demo" {
  name         = "${var.env}-demorudola-db"
  server_id    = azurerm_mssql_server.demo.id
  max_size_gb  = 2
  sku_name     = "S0"

  tags = {
    name = var.env
  }
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.demo.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}