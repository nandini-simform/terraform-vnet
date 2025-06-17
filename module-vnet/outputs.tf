output "public_ip_address" {
  value = azurerm_public_ip.pubip.ip_address
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}