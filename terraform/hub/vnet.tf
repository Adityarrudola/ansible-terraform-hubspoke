# nsg
resource "azurerm_network_security_group" "demo" {
  name                = "${var.env}-sg"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  dynamic "security_rule" {
    for_each = var.inbound_rules
    content {
      name                       = "inbound-rule-${security_rule.value.destination_port_range}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.outbound_rules
    content {
      name                       = "outbound-rule-${security_rule.value.destination_port_range}"
      priority                   = security_rule.value.priority
      direction                  = "Outbound"
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = {
    name = var.env
  }
}

# vnet
resource "azurerm_virtual_network" "demo" {
  name                = "${var.env}-vnet"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    name = var.env
  }
}

# subnet
resource "azurerm_subnet" "demo" {
  name                 = "${var.env}-subnet"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.1.0/24"]
}

# nsg association to subnet
resource "azurerm_subnet_network_security_group_association" "demo" {
  subnet_id                 = azurerm_subnet.demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}