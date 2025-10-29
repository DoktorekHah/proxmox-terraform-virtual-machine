variable "name_vm" {
  description = "The name of the VM"
  type        = string
  default     = "vm"
}

variable "node_name" {
  description = "The name of the Proxmox node to create the VM on"
  type        = string
}

variable "pool_id" {
  description = "The ID of the pool to add the VM to"
  type        = string
  default     = null
}

variable "vm_id" {
  description = "The ID of the VM"
  type        = number
  default     = 100
  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 2147483647
    error_message = "VM ID must be between 100 and 2147483647"
  }
}

variable "description" {
  description = "The description of the VM"
  type        = string
  default     = "Managed by Terraform"
}

variable "cagent_qemu_enabled" {
  description = "Whether to enable the QEMU guest agent"
  type        = bool
  default     = false
}

variable "stop_on_destroy" {
  description = "Whether to stop the VM before destroying it"
  type        = bool
  default     = true
}

variable "ipv4_address" {
  description = "The IPv4 address configuration for the VM"
  type        = string
  default     = "dhcp/24"
}

variable "gateway" {
  description = "The gateway configuration for the VM"
  type        = string
  default     = "dhcp"
}

variable "disk" {
  description = "The disk configuration for the VM"
  type = map(object({
    cache        = optional(string, "none")
    datastore_id = string
    file_format  = optional(string, "raw")
    file_id      = optional(string)
    interface    = string
    size         = string
    ssd          = optional(bool, false)
    iothread     = optional(bool, false)
    discard      = optional(string, "ignore")
    replicate    = optional(bool, true)
  }))
  default     = {}
}

variable "efi_disk" {
  description = "The EFI disk configuration for the VM"
  type = map(object({
    datastore_id = string
    file_format  = optional(string, "raw")
    type         = optional(string, "4m")
    pre_enrolled_keys = optional(bool, false)
  }))
  default     = {}
}

variable "username" {
  description = "The username for the VM user account"
  type        = string
  default     = null
}

variable "password" {
  description = "The password for the VM user account"
  type        = string
  default     = null
}

variable "tpm_state" {
  description = "The TPM state configuration for the VM"
  type = map(object({
    version      = optional(string, "v2.0")
    datastore_id = string
  }))
  default     = {}
}

variable "os_config" {
  description = "The operating system configuration type"
  type        = string
  default     = "l26" #kernel 2.6 -> 5.* | win11
}

variable "os_type" {
  description = "The operating system type"
  type        = string
  default     = "linux"
}

variable "machine" {
  description = "The machine type (q35 or i440fx)"
  type        = string
  default     = "q35"
  validation {
    condition     = contains(["q35", "i440fx"], var.machine)
    error_message = "Machine type must be either q35 or i440fx"
  }
}

variable "started" {
  description = "Whether to start the VM after creation"
  type        = bool
  default     = false
}

variable "reboot_vm" {
  description = "Whether to reboot the VM after creation"
  type        = bool
  default     = false
}

variable "template_vm" {
  description = "Whether to create the VM as a template"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "The SSH public key for the VM"
  type        = string
  default     = ""
}

variable "private_key_name" {
  description = "The name for the private SSH key file"
  type        = string
  default     = "mysshkey"
}

variable "public_key_name" {
  description = "The name for the public SSH key file"
  type        = string
  default     = "mysshkey.pub"
}

variable "ssh_key_gen" {
  description = "Whether to generate SSH keys automatically"
  type        = bool
  default     = false
}

variable "ssh_key_gen_algorithm" {
  description = "ECDSA, RSA #RSA, ECDSA, ED25519"
  type        = string
  default     = "ECDSA"
}

variable "ssh_key_gen_rsa_bits" {
  description = "The number of bits for RSA key generation"
  type        = number
  default     = 4096
}

variable "ssh_key_gen_ecdsa_curve" {
  description = "Algorithm is ECDSA Currently-supported values are: P224, P256, P384, P521."
  type        = string
  default     = "P224"
}

variable "user_data_file_id" {
  description = "The user data file ID for cloud-init"
  type        = string
  default     = ""
}

variable "bios" {
  description = "The BIOS type (seabios or ovmf)"
  type        = string
  default     = "ovmf"
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "BIOS type must be either seabios or ovmf"
  }
}

variable "architecture" {
  description = "The CPU architecture (x86_64 or aarch64)"
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["x86_64", "aarch64"], var.architecture)
    error_message = "Architecture must be either x86_64 or aarch64"
  }
}

variable "cores" {
  description = "The number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "The amount of memory in MB"
  type        = number
  default     = 1024
}

variable "network_device" {
  description = "The network device configuration for the VM"
  type = map(object({
    bridge      = string
    model       = string
    enabled     = bool
    vlan_id     = optional(number)
    mac_address = optional(string)
    mtu         = optional(number)
    rate_limit  = optional(number)
    firewall    = optional(bool, true)
  }))
  default     = {
    eth0 = {
      bridge  = "vmbr0"
      model   = "virtio"
      enabled = true
    }
  }
}

variable "tags" {
  description = "The tags to apply to the VM"
  type        = list(string)
  default     = [
    "Terraform", "true",
    "Tags"
  ]
}

variable "datastore_cloudinit" {
  description = "The datastore ID for cloud-init"
  type        = string
  default     = null
}

variable "usb" {
  description = "The USB device configuration for the VM"
  type = map(object({
    host    = optional(string)
    mapping = optional(string)
    usb3    = optional(bool, false)
  }))
  default     = {}
}

variable "dns_domain" {
  description = "The DNS domain for the VM"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "The DNS servers for the VM"
  type        = list(string)
  default     = null
}

variable "content_type" {
  description = "The content type for file uploads"
  type        = string
  default     = "iso"
  validation {
    condition     = contains(["dump", "iso", "snippets", "vztmpl"], var.content_type)
    error_message = "You must choose from dump, iso, snippets, vztmpl"
  }
}

variable "datastore_id" {
  description = "The datastore ID for file storage"
  type        = string
  default     = null
}

variable "file_mode" {
  description = "The file mode for uploaded files"
  type        = string
  default     = null
}

variable "upload_timeout" {
  description = "The timeout for file uploads in seconds"
  type        = number
  default     = 1800
}

variable "path" {
  description = "The path to the file to upload"
  type        = string
  default     = null
}

variable "checksum" {
  description = "The checksum for file verification"
  type        = string
  default     = null
}

variable "file_name" {
  description = "The name of the file to upload"
  type        = string
  default     = null
}

variable "insecure" {
  description = "Whether to allow insecure connections"
  type        = string
  default     = null
}

variable "data" {
  description = "The raw data to upload"
  type        = string
  default     = null
}

variable "resize" {
  description = "Whether to resize the file"
  type        = string
  default     = null
}

variable "startup" {
  description = "The startup configuration for the VM"
  type = object({
    order      = optional(number, 0)
    up_delay   = optional(number)
    down_delay = optional(number)
  })
  default     = {
   order = 0   
  }
}

variable "serial_device" {
  description = "The serial device configuration for the VM"
  type = object({
    device = optional(string, "socket")
  })
  default = null
}