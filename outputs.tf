output "outputs_vm" {
  value = {
    id      = proxmox_virtual_environment_vm.this.id
    vm_name = proxmox_virtual_environment_vm.this.name
  }
  description = "VM id, name"
}

output "env_files" {
  value = {
    id_source_file = proxmox_virtual_environment_file.source_file
    id_source_raw  = proxmox_virtual_environment_file.source_raw
    path           = proxmox_virtual_environment_file.source_file
    data           = proxmox_virtual_environment_file.source_raw
  }
  description = "Environment files information including source file ID, raw file ID, path, and data"
}