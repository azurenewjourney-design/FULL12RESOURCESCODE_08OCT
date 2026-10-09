data "azurerm_subnet" "subnet" {
  for_each = var.virtual_machines

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

data "azurerm_public_ip" "pip" {
  for_each = var.virtual_machines

  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  for_each = var.virtual_machines

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip[each.key].id
  }
}

output "nic_ids" {
  value = {
    for key, nic in azurerm_network_interface.nic :
    key => nic.id
  }
}