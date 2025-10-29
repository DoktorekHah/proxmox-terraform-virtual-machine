# ## https://gist.github.com/gabeduke/7ccb3f3147d79ac30e2187432808060c cloudinit
# # ## https://docs.docker.com/engine/install/sles/
# # # ##


# module "debian_docker" {
#   source = "../../proxmox_terraform/modules/virtual_machine"
#   providers = {
#     proxmox = proxmox.app
#   }
#   count      = 1
#   name_vm    = "test"
#   node_name  = var.node_name
#   datastore_id = data.proxmox_virtual_environment_datastores.this.datastore_ids[2]
#   vm_id      = 1000
#   cores      = 1
#   memory     = 2048
#   agent_qemu_enabled = true

#   username         = "root"
#   ssh_public_key   = trimspace(data.local_file.ssh_public_key.content)
#   ssh_key_gen = false
#   os_config           = "l26"
#   bios                = "seabios"
#   started             = true
#   reboot_vm           = false
#   #datastore_cloudinit = data.proxmox_virtual_environment_datastores.this..datastore_ids[2]

#   tags = ["pfsense", "opentofu"]

#   disk = {
#     os = {
#       cache        = "none"
#       datastore_id = data.proxmox_virtual_environment_datastores.this.datastore_ids[2]
#       file_format  = "qcow2"
#       file_id      =  module.os_images.datastore_download_file["debian12"].id
#       interface    = "virtio0"
#       size         = "32"
#     }
#   }

#   network_device = {
#     lan = {
#       bridge  = module.network_card_vm.network_interface["vm_lan"].name
#       model = "e1000"
#       vlan_id = 0
#       enabled = true
#     }
#   }
#   ipv4_address = "192.168.50.222/24"
#   gateway = "192.168.50.1"

#   template_vm = false

#   #depends_on = [module.pfsense_image]

# }

# # output image {
# #     value = module.pfsense_image.datastore_download_file["pfsense"].id
# # }

# # output datastore {
# #     value = data.proxmox_virtual_environment_datastores.pv1.datastore_ids[2]
# # }

