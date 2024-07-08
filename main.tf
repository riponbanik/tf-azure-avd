# Resources group
resource "azurerm_resource_group" "avd" {
  name     = "rg-avd"
  location = "australiaeast"
  tags     = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
