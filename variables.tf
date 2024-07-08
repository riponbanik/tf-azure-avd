# Session Hosts
variable "avd_host_pool_size" {
  type        = number
  description = "Number of session hosts to add to the AVD host pool."
  default     = 1
}

# AADDS-join 
variable "avd_ou_path" {
  type        = string
  description = "OU path used to AADDS domain-join AVD session hosts."
  default     = ""
}


# Register VMs to the Host Pool
variable "avd_register_session_host_modules_url" {
  type        = string
  description = "URL to .zip file containing DSC configuration to register AVD session hosts to AVD host pool."
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"
}

# RBAC

# Assuming that we want to authorize users that already exist within our AAD
variable "avd_user_upns" {
  type        = list(string)
  description = "List of user UPNs authorized to access AVD."
  default     = []
}

variable "location" {
  description = "Azure location."
  type        = string
  default     = "Australia East"
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default = {
  }
}

locals {
  # Sydney
  avd_location = "australiaeast"
}
