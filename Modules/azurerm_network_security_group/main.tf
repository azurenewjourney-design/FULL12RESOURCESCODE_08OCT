resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "nsg_ids" {
  value = {
    for key, nsg in azurerm_network_security_group.nsg :
    key => nsg.id
  }
}