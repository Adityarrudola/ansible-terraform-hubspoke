resource "local_file" "ansible_inventory" {

  filename = "${path.root}/../../ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    dev1_ip = data.terraform_remote_state.dev1.outputs.dev1_public_ip
    dev2_ip = data.terraform_remote_state.dev2.outputs.dev2_public_ip
  })
}
