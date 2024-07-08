# Azure AD/Entra Join
resource "azurerm_virtual_machine_extension" "AADLoginForWindows" {
  count                      = var.avd_host_pool_size
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd[count.index].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


