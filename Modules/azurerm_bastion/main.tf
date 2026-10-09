data "azurerm_virtual_network" "vnet" {
  name                = var.bastion.virtual_network_name
  resource_group_name = var.bastion.resource_group_name
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.bastion.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion.subnet_address_prefix]
}

resource "azurerm_public_ip" "bastion" {
  name                = var.bastion.public_ip_name
  resource_group_name = var.bastion.resource_group_name
  location            = var.bastion.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion.name
  location            = var.bastion.location
  resource_group_name = var.bastion.resource_group_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}