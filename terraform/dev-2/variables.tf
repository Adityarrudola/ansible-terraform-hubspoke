variable "env" {
  type    = string
  default = "dev-2"
}

variable "location" {
  type    = string
  default = "Southeast Asia"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2as_v2"
}

variable "inbound_rules" {
  type = list(object({
    priority               = string
    access                 = string
    protocol               = string
    destination_port_range = string
  }))
  default = [
    { priority = "200", access = "Allow", protocol = "*", destination_port_range = "22" }
  ]
}

variable "outbound_rules" {
  type = list(object({
    priority               = string
    access                 = string
    protocol               = string
    destination_port_range = string
  }))
  default = [

  ]
}
