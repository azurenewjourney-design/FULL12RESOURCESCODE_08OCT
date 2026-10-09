variable "resource_group_name" {}

variable "storage_account" {}

variable "virtual_networks" {}

variable "subnets" {}

variable "virtual_machines" {}

variable "public_ips" {}

variable "nsg" {}

variable "bastion" {
  type = object({
    name                  = string
    resource_group_name   = string
    location              = string
    virtual_network_name  = string
    subnet_address_prefix = string
    public_ip_name        = string
  })
}

variable "load_balancer" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    public_ip_name      = string
  })
}

variable "application_gateway" {
  type = object({
    name                  = string
    resource_group_name   = string
    location              = string
    virtual_network_name  = string
    subnet_address_prefix = string
    public_ip_name        = string
  })
}