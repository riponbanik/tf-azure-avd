# we add the VM NICs for the session hosts
resource "azurerm_network_interface" "avd" {
  count               = var.avd_host_pool_size
  name                = "avd-nic-${count.index}"
  location            = azurerm_resource_group.avd.location
  resource_group_name = azurerm_resource_group.avd.name

  ip_configuration {
    name                          = "avd-ipconf"
    subnet_id                     = azurerm_subnet.avd.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

# we add the session hosts
resource "random_password" "avd_local_admin" {
  length = 64
}

resource "random_id" "avd" {
  count       = var.avd_host_pool_size
  byte_length = 2
}


# Virtual Machine
resource "azurerm_windows_virtual_machine" "avd" {
  count               = var.avd_host_pool_size
  name                = "avdvm${count.index}${random_id.avd[count.index].hex}"
  location            = azurerm_resource_group.avd.location
  resource_group_name = azurerm_resource_group.avd.name
  tags                = var.tags

  size                  = "Standard_D4s_v4"
  license_type          = "Windows_Client" # To ensure the session hosts utilize the licensing benefits available with AVD
  admin_username        = "localadmin"
  admin_password        = random_password.avd_local_admin.result
  network_interface_ids = [azurerm_network_interface.avd[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
