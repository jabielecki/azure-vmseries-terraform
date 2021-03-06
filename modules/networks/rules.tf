# Permit the traffic between the vmseries VNET and the Panorama VNET
resource "azurerm_network_security_rule" "inter-vnet-rule" {
  name = "${var.name_prefix}-sgrule-intervnet"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Inbound"
  network_security_group_name = azurerm_network_security_group.sg-panorama-mgmt.name
  priority = 200
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = azurerm_subnet.subnet-mgmt.address_prefix
  destination_address_prefix = "0.0.0.0/0"
  destination_port_range = "*"
}
# Permit All outbound traffic in vm-series Management VNET
resource "azurerm_network_security_rule" "vmseries-allowall-outbound" {
  name = "${var.name_prefix}-sgrule-outbound"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Outbound"
  network_security_group_name = azurerm_network_security_group.sg-mgmt.name
  priority = 100
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  destination_port_range = "*"
}
# Allow all vnets to talk to the VM management network
resource "azurerm_network_security_rule" "vmseries-mgmt-inbound" {
  name = "${var.name_prefix}-sgrule-mgmt"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Inbound"
  network_security_group_name = azurerm_network_security_group.sg-mgmt.name
  priority = 101
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = azurerm_subnet.subnet-panorama-mgmt.address_prefix
  destination_address_prefix = "*"
  destination_port_range = "*"
}

# Permit All outbound traffic in Panorma Managemnet VNET
resource "azurerm_network_security_rule" "panorama-allowall-outbound" {
  name = "${var.name_prefix}-sgrule-allowmgmt"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Outbound"
  network_security_group_name = azurerm_network_security_group.sg-panorama-mgmt.name
  priority = 100
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  destination_port_range = "*"
}

# Permit All Inbound traffic in Outside VNET
# required due to Standard type LB
resource "azurerm_network_security_rule" "outside-allowall-inbound" {
  name = "${var.name_prefix}-sgrule-allowin"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Inbound"
  network_security_group_name = azurerm_network_security_group.sg-allowall.name
  priority = 100
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  destination_port_range = "*"
}
resource "azurerm_network_security_rule" "outside-allowall-outbound" {
  name = "${var.name_prefix}-sgrule-allowout"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Outbound"
  network_security_group_name = azurerm_network_security_group.sg-allowall.name
  priority = 101
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  destination_port_range = "*"
}

# Permit the external (admin) ips access  to the management networks.
resource "azurerm_network_security_rule" "management-rules" {
  for_each = var.management_ips
  name = "${var.name_prefix}-panorama-mgmt-sgrule-${each.value}-mgmt"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Inbound"
  network_security_group_name = azurerm_network_security_group.sg-panorama-mgmt.name
  priority = each.value
  protocol = "Tcp"
  source_port_range = "*"
  source_address_prefix = each.key
  destination_address_prefix = "0.0.0.0/0"
  destination_port_range = "*"
}

# Permit the external (admin) ips access  to the management networks.
resource "azurerm_network_security_rule" "vm-management-rules" {
  for_each = var.management_ips
  name = "${var.name_prefix}-panorama-mgmt-sgrule-${each.value}-mgmt"
  resource_group_name = azurerm_resource_group.rg.name
  access = "Allow"
  direction = "Inbound"
  network_security_group_name = azurerm_network_security_group.sg-mgmt.name
  priority = each.value
  protocol = "Tcp"
  source_port_range = "*"
  source_address_prefix = each.key
  destination_address_prefix = "0.0.0.0/0"
  destination_port_range = "*"
}