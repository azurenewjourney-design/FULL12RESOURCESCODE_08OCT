resource "azurerm_public_ip" "lb" {
  name                = var.load_balancer.public_ip_name
  resource_group_name = var.load_balancer.resource_group_name
  location            = var.load_balancer.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = var.load_balancer.name
  resource_group_name = var.load_balancer.resource_group_name
  location            = var.load_balancer.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  for_each = var.nic_ids

  network_interface_id    = each.value
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}