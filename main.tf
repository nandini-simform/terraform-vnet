module "virtual_network" {
  source = "./module-vnet"

  resource_group_name      = var.resource_group_name
  resource_group_location  = var.resource_group_location
  virtual_network_name     = var.virtual_network_name
  vnet_address_space       =var.vnet_address_space
  subnets = var.subnets
  enable_peering           = false
  peerings                 = {}
  enable_nsg               = false
  nsgs                     = {}
  nic                      = var.nic
  public_ip                = var.public_ip
}