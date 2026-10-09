data "azurerm_virtual_network" "vnet" {
  name                = var.application_gateway.virtual_network_name
  resource_group_name = var.application_gateway.resource_group_name
}

resource "azurerm_subnet" "app_gateway" {
  name                 = "ApplicationGatewaySubnet"
  resource_group_name  = var.application_gateway.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.application_gateway.subnet_address_prefix]
}

resource "azurerm_public_ip" "app_gateway" {
  name                = var.application_gateway.public_ip_name
  resource_group_name = var.application_gateway.resource_group_name
  location            = var.application_gateway.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.application_gateway.name
  resource_group_name = var.application_gateway.resource_group_name
  location            = var.application_gateway.location

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }
  
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.app_gateway.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontend"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name = "appGatewayBackendPool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appGatewayFrontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }

  depends_on = [
    azurerm_subnet.app_gateway
  ]
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "backend" {
  for_each = var.nic_ids

  network_interface_id    = each.value
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = tolist(azurerm_application_gateway.app_gateway.backend_address_pool)[0].id
}