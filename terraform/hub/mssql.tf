resource "azurerm_mssql_server" "demo" {
  name                         = "${var.env}-demorudola-sqlserver"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_password
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