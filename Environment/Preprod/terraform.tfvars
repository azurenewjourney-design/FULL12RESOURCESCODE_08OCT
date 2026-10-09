resource_group_name = {

  "ankit" = "East US"

}

storage_account = {
  "sa1" = {
    name                     = "storageaccount10754"
    resource_group_name      = "ankit"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
  }

}

virtual_networks = {
  "vnet1" = {
    name                = "vnet1"
    resource_group_name = "ankit"
    location            = "East US"
    address_space       = ["10.0.0.0/16"]
  }
}

subnets = {
  "subnet1" = {
    name                 = "subnet1"
    resource_group_name  = "ankit"
    virtual_network_name = "vnet1"
    address_prefixes     = ["10.0.1.0/24"]
  }
}

bastion = {
  name                  = "bastion-preprod"
  resource_group_name   = "ankit"
  location              = "East US"
  virtual_network_name  = "vnet1"
  subnet_address_prefix = "10.0.2.0/26"
  public_ip_name        = "pip-bastion-preprod"
}

virtual_machines = {
  "vm1" = {
    name                 = "vm1"
    resource_group_name  = "ankit"
    location             = "East US"
    size                 = "Standard_D2s_v4"
    admin_username       = "adminuser"
    admin_password       = "YourStrongPassword123!"
    virtual_network_name = "vnet1"
    subnet_name          = "subnet1"
    public_ip_name       = "pip1"
  }

  "vm2" = {
    name                 = "vm2"
    resource_group_name  = "ankit"
    location             = "East US"
    size                 = "Standard_D2s_v4"
    admin_username       = "adminuser"
    admin_password       = "YourStrongPassword123!"
    virtual_network_name = "vnet1"
    subnet_name          = "subnet1"
    public_ip_name       = "pip2"
  }
}

public_ips = {
  "pip1" = {
    name                = "pip1"
    resource_group_name = "ankit"
    location            = "East US"
    allocation_method   = "Static"
  }

  "pip2" = {
    name                = "pip2"
    resource_group_name = "ankit"
    location            = "East US"
    allocation_method   = "Static"
  }
}

nsg = {
  "vm1" = {
    name                = "vm1-nsg"
    resource_group_name = "ankit"
    location            = "East US"
  }

  "vm2" = {
    name                = "vm2-nsg"
    resource_group_name = "ankit"
    location            = "East US"
  }
}

load_balancer = {
  name                = "lb-preprod"
  resource_group_name = "ankit"
  location            = "East US"
  public_ip_name      = "pip-lb-preprod"
}

application_gateway = {
  name                  = "appgw-preprod"
  resource_group_name   = "ankit"
  location              = "East US"
  virtual_network_name  = "vnet1"
  subnet_address_prefix = "10.0.3.0/24"
  public_ip_name        = "pip-appgw-preprod"
}
  