resource "azurerm_virtual_desktop_host_pool" "avd" {
  name                = "avd-vdpool"
  location            = var.location
  resource_group_name = azurerm_resource_group.avd.name

  type                  = "Pooled"
  load_balancer_type    = "BreadthFirst"
  friendly_name         = "AVD Host Pool using AADDS"
  validate_environment  = false
  start_vm_on_connect   = false
  custom_rdp_properties = "enablecredsspsupport:i:1;videoplaybackmode:i:1;audiomode:i:0;devicestoredirect:s:*;drivestoredirect:s:*;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;redirectwebauthn:i:1;usbdevicestoredirect:s:*;use multimon:i:1;targetisaadjoined:i:1;"
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "time_rotating" "avd_registration_expiration" {
  # Must be between 1 hour and 30 days
  rotation_days = 29
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avd" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd.id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}
