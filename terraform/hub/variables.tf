variable "env" {
  type    = string
  default = "hub"
}

variable "location" {
  type    = string
  default = "Southeast Asia"
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
