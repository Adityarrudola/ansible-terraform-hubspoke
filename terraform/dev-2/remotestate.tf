data "terraform_remote_state" "hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-rg"
    storage_account_name = "rterraformremotebackend"
    container_name       = "ansible-terraform-state"
    key                  = "hub/infra.tfstate"
  }
}