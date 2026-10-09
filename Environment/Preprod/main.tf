module "rgs" {
  source              = "../../Modules/azurerm_resource_group"
  resource_group_name = var.resource_group_name
}

module "storage_account" {
  depends_on = [module.rgs]

  source          = "../../Modules/azurerm_storage_account"
  storage_account = var.storage_account
}

module "virtual_network" {
  depends_on = [module.rgs]

  source           = "../../Modules/azurerm_virtual_network"
  virtual_networks = var.virtual_networks
}

module "subnet" {
  depends_on = [
    module.virtual_network,
    module.rgs
  ]

  source  = "../../Modules/azurerm_subnet"
  subnets = var.subnets
}

module "public_ip" {
  depends_on = [module.rgs]

  source     = "../../Modules/azurerm_public_ip"
  public_ips = var.public_ips
}

module "nic" {
  depends_on = [
    module.subnet,
    module.public_ip,
    module.rgs
  ]

  source           = "../../Modules/azurerm_nic"
  virtual_machines = var.virtual_machines
}

module "nsg" {
  depends_on = [module.rgs]

  source = "../../Modules/azurerm_network_security_group"
  nsgs   = var.nsg
}

module "virtual_machine" {
  depends_on = [
    module.nic,
    module.rgs
  ]

  source           = "../../Modules/azurerm_virtual_machine"
  virtual_machines = var.virtual_machines
  nic_ids          = module.nic.nic_ids
}

module "nic_nsg_association" {
  depends_on = [
    module.nic,
    module.nsg
  ]

  source = "../../Modules/azurerm_nic_nsg_association"

  associations = {
    for key, vm in var.virtual_machines : key => {
      nic_id = module.nic.nic_ids[key]
      nsg_id = module.nsg.nsg_ids[key]
    }
  }
}

module "bastion" {
  depends_on = [module.rgs]

  source = "../../Modules/azurerm_bastion"

  bastion = var.bastion
}

module "load_balancer" {
  depends_on = [module.nic]

  source = "../../Modules/azurerm_load_balancer"

  load_balancer = var.load_balancer
  nic_ids       = module.nic.nic_ids
}

module "application_gateway" {
  depends_on = [module.nic]

  source = "../../Modules/azurerm_application_gateway"

  application_gateway = var.application_gateway
  nic_ids             = module.nic.nic_ids
}