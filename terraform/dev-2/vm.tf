# public ip
resource "azurerm_public_ip" "demo" {
  name                = "${var.env}-public-ip"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Static"

  tags = {
    name = var.env
  }
}

# network interface
resource "azurerm_network_interface" "demo" {
  name                = "${var.env}-nic"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "${var.env}-ipconfig"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo.id
  }
  
  depends_on = [
    azurerm_public_ip.demo
  ]

  tags = {
    name = var.env
  }
}

# vm
resource "azurerm_linux_virtual_machine" "demo" {
  name                = "${var.env}-vm"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  size                = var.vm_size
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.demo.id
  ]

  identity {
    type = "SystemAssigned"
  }
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("../../keys/demo.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


  depends_on = [
    azurerm_network_interface.demo
  ]

  tags = {
    name = var.env
  }
}