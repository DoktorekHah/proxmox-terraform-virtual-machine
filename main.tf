resource "proxmox_virtual_environment_vm" "this" {
  provider = proxmox

  name        = var.name_vm
  description = var.description
  node_name   = var.node_name
  vm_id       = var.vm_id
  pool_id     = var.pool_id

  machine = var.machine
  bios    = var.bios
  started = var.started
  reboot  = var.reboot_vm

  tags = var.tags
    #local.module_tags
  agent {
    enabled = var.cagent_qemu_enabled
  }

  stop_on_destroy = var.stop_on_destroy

  startup {
    order      = var.startup.order
    up_delay   = var.startup.up_delay
    down_delay = var.startup.down_delay
  }

  dynamic "tpm_state" {
    for_each = var.tpm_state
    content {
      version      = tpm_state.value.tpm_version
      datastore_id = tpm_state.value.tpm_datastore_id
    }
  }

  dynamic "disk" {
    for_each = var.disk
    content {
      cache        = disk.value.cache
      datastore_id = disk.value.datastore_id
      file_format  = disk.value.file_format
      file_id      = disk.value.file_id
      interface    = disk.value.interface
      size         = disk.value.size
    }
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk
    content {
      datastore_id = var.bios == "ovmf" ? efi_disk.value.datastore_id : 0
      file_format  = var.bios == "ovmf" ? efi_disk.value.file_format : 0
      type         = var.bios == "ovmf" ? efi_disk.value.type : 0
    }
  }

  initialization {
    datastore_id = var.datastore_cloudinit
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.gateway
      }
    }

    user_account {
      keys     = var.os_type == "linux" ? local.ssh_keys : null
      password = var.password
      username = var.username
    }

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }

    user_data_file_id = var.user_data_file_id
  }

  cpu {
    architecture = var.architecture
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  dynamic "network_device" {
    for_each = var.network_device
    content {
      bridge  = network_device.value.bridge
      model   = network_device.value.model
      vlan_id = network_device.value.vlan_id
      enabled = network_device.value.enabled
    }
  }

  operating_system {
    type = var.os_config
  }

  dynamic "usb" {
    for_each = var.usb
    content {
      host    = usb.value.host
      mapping = usb.value.mapping
      usb3    = usb.value.usb3
    }
  }

  dynamic "serial_device" {
    for_each = var.serial_device != null ? [var.serial_device] : []
    content {
      device = serial_device.value.device
    }
  }

  lifecycle {
    ignore_changes = [
      id,
      cpu,
      network_device,
      disk,
      initialization,
    ]
  }

  template = var.template_vm
}