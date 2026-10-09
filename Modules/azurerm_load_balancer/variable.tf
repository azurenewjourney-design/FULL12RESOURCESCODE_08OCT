variable "load_balancer" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    public_ip_name      = string
  })
}

variable "nic_ids" {
  type = map(string)
}