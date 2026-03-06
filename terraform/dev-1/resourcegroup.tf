resource azurerm_resource_group demo {
  name = "${var.env}-rg"
  location = var.location
}