resource "azurerm_virtual_desktop_workspace" "avd" {
  name                = "avd-vdws"
  location            = local.avd_location
  resource_group_name = azurerm_resource_group.avd.name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_virtual_desktop_application_group" "avd" {
  name                = "avd-dag"
  location            = local.avd_location
  resource_group_name = azurerm_resource_group.avd.name
  tags                = var.tags

  type         = "Desktop" # Desktop: full desktop, RemoteApp: individual apps
  host_pool_id = azurerm_virtual_desktop_host_pool.avd.id

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "avd" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd.id
  application_group_id = azurerm_virtual_desktop_application_group.avd.id
}
