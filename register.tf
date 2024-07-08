
resource "azurerm_virtual_machine_extension" "avd_register_session_host" {
  count                = var.avd_host_pool_size
  name                 = "register-session-host-vmext"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd[count.index].id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<-SETTINGS
    {
      "modulesUrl": "${var.avd_register_session_host_modules_url}",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName": "${azurerm_virtual_desktop_host_pool.avd.name}",
        "aadJoin": false
      }
    }
    SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.avd.token}"
      }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [tags, settings, protected_settings]
  }

  depends_on = [azurerm_virtual_machine_extension.AADLoginForWindows]
}
