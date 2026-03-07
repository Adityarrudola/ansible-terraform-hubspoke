data "terraform_remote_state" "dev2" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateaditya"
    container_name       = "tfstate"
    key                  = "dev2/terraform.tfstate"
  }
}