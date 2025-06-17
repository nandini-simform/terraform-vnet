variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}
variable "virtual_network_name" {
  description = "Name of virtual network "
  type = string
}
variable "vnet_address_space" {
  description = "The base value of vnet address space"
  type = list(string)
}

variable "subnets" {
      type = map(object({
    address_prefix = string
    nsg_name       = optional(string)  # NSG to attach (optional)
  }))
  default = {}  #empty means no subnet
}

variable "enable_peering" {
  description = "Enable or disable virtual network peering"
  type        = bool
  default     = false
}

variable "peerings" {
  description = "Configuration for virtual network peerings"
  type = map(object({
    remote_virtual_network_id = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic = optional(bool, false)
    allow_gateway_transit = optional(bool, false)
    use_remote_gateways = optional(bool, false)
  }))
  default = {}
}

variable "enable_nsg" {
  description = "Enable or disable network security groups"
  type        = bool
  default     = false
}

variable "nsgs" {
  type = map(object({
    location         = string
    resource_group   = string
    security_rules   = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
  
}
variable "nic" {
  type = string
}
variable "public_ip" {
  type = string
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP"
  type        = string
  default     = "Dynamic"
}
