data "terraform_remote_state" "hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-rg"
    storage_account_name = "rterraformremotebackend"
    container_name       = "ansible-terraform-state"
    key                  = "hub/infra.tfstate"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.terraform_remote_state.hub.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.demo.identity[0].principal_id
}