resource "random_password" "password" {
  provider = random
  length           = 24
  override_special = "!*()=-+[]{}<>_%@.:"
  special          = true
}

locals {
  version = "1.0.0"
  name = "vm"
  module_tags = merge({"version" = local.version, "name" = local.name})

  tls       = "1.3"
  ssh_keys = var.ssh_key_gen != true ? [trimspace(var.ssh_public_key)] : [trimspace(local_sensitive_file.public_key[0].content)]
}