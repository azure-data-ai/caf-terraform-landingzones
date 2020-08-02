# Resource Group - Landing Zone
resource "azurerm_resource_group" "dap_network_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    country     = var.country
  }
}

# VNet
resource "azurerm_virtual_network" "dap_vnet" {
  name                = var.dap_vnet_name
  location            = azurerm_resource_group.dap_network_rg.location
  resource_group_name = azurerm_resource_group.dap_network_rg.name
  address_space       = var.vnet_address_space
}

# Create the vm private-subnet
resource "azurerm_subnet" "gtwy_subnet" {
  name                      = var.gateway_subnet
  resource_group_name       = azurerm_resource_group.dap_network_rg.name
  virtual_network_name      = azurerm_virtual_network.dap_vnet.name
  address_prefixes          = var.gateway_subnet_address
}

# Network interface for VM
resource "azurerm_network_interface" "gtwy_vm_nic" {
  name                = var.vm_network_interface
  resource_group_name = azurerm_resource_group.dap_network_rg.name
  location            = azurerm_resource_group.dap_network_rg.location

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.gtwy_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine[Gateway server]
resource "azurerm_virtual_machine" "jumpserver_vm" {
  name                  = var.gateway_vm
  location              = azurerm_resource_group.dap_network_rg.location
  resource_group_name   = azurerm_resource_group.dap_network_rg.name
  network_interface_ids = [azurerm_network_interface.gtwy_vm_nic.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "dsvm-windows"
    sku       = "server-2019"
    version   = "latest"
  }
  os_profile {
    computer_name  = var.os_computer_name
    admin_username = var.os_adminuser
    admin_password = var.os_password
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  storage_os_disk {
    name              = "${var.os_computer_name}-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vm_managed_disk_type
  }
}
