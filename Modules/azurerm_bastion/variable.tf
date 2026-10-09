variable "bastion" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    virtual_network_name = string
    subnet_address_prefix = string
    public_ip_name      = string
  })
}