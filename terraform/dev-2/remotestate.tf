data "terraform_remote_state" "hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-rg"
    storage_account_name = "terraformbackend"
    container_name       = "tfstate"
    key                  = "hub/terraform.tfstate"
  }
}