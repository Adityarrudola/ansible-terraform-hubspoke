resource "azurerm_virtual_network_peering" "dev1_to_dev2" {
  name                      = "dev1-to-dev2"
  resource_group_name       = data.terraform_remote_state.dev1.outputs.dev1_rg_name
  virtual_network_name      = data.terraform_remote_state.dev1.outputs.dev1_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.dev2.outputs.dev2_vnet_id

  allow_virtual_network_access = true
}


resource "azurerm_virtual_network_peering" "dev2_to_dev1" {
  name                      = "dev2-to-dev1"
  resource_group_name       = data.terraform_remote_state.dev2.outputs.dev2_rg_name
  virtual_network_name      = data.terraform_remote_state.dev2.outputs.dev2_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.dev1.outputs.dev1_vnet_id

  allow_virtual_network_access = true
}


resource "azurerm_virtual_network_peering" "dev1_to_hub" {
  name                      = "dev1-to-hub"
  resource_group_name       = data.terraform_remote_state.dev1.outputs.dev1_rg_name
  virtual_network_name      = data.terraform_remote_state.dev1.outputs.dev1_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.hub.outputs.hub_vnet_id

  allow_virtual_network_access = true
}


resource "azurerm_virtual_network_peering" "hub_to_dev1" {
  name                      = "hub-to-dev1"
  resource_group_name       = data.terraform_remote_state.hub.outputs.hub_rg_name
  virtual_network_name      = data.terraform_remote_state.hub.outputs.hub_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.dev1.outputs.dev1_vnet_id

  allow_virtual_network_access = true
}


resource "azurerm_virtual_network_peering" "dev2_to_hub" {
  name                      = "dev2-to-hub"
  resource_group_name       = data.terraform_remote_state.dev2.outputs.dev2_rg_name
  virtual_network_name      = data.terraform_remote_state.dev2.outputs.dev2_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.hub.outputs.hub_vnet_id

  allow_virtual_network_access = true
}


resource "azurerm_virtual_network_peering" "hub_to_dev2" {
  name                      = "hub-to-dev2"
  resource_group_name       = data.terraform_remote_state.hub.outputs.hub_rg_name
  virtual_network_name      = data.terraform_remote_state.hub.outputs.hub_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.dev2.outputs.dev2_vnet_id

  allow_virtual_network_access = true
}