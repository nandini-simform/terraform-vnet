resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]

  # Removed network_security_group_id as it is not valid for azurerm_subnet resource
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group

  dynamic "security_rule" {
    for_each = each.value.security_rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_virtual_network_peering" "peerings" {
  for_each = var.peerings

  name                        = "${azurerm_virtual_network.vnet.name}-to-${each.key}"
  resource_group_name         = var.resource_group_name
  virtual_network_name        = azurerm_virtual_network.vnet.name
  remote_virtual_network_id   = each.value.remote_virtual_network_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}
resource "azurerm_public_ip" "pubip" {
    name                = var.public_ip
    location            = var.resource_group_location
    resource_group_name = var.resource_group_name
    allocation_method   = var.public_ip_allocation_method
}
resource "azurerm_network_interface" "nic" {
  name = var.nic
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "internal"
    subnet_id =  values(azurerm_subnet.subnets)[0].id
    private_ip_address_allocation = "Dynamic"
   
  }
}

