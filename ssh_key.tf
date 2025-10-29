resource "tls_private_key" "this" {
  count = var.ssh_key_gen ? 1 : 0
  provider = tls

  algorithm   = var.ssh_key_gen_algorithm
  rsa_bits    = var.ssh_key_gen_algorithm == "RSA" ? var.ssh_key_gen_rsa_bits : null
  ecdsa_curve = var.ssh_key_gen_algorithm == "ECDSA" ? var.ssh_key_gen_ecdsa_curve : null
}

# Save private key locally.
resource "local_sensitive_file" "private_key" {
  count    = var.ssh_key_gen ? 1 : 0
  provider = local

  content         = tls_private_key.this[0].private_key_openssh
  filename        = var.private_key_name
  file_permission = "0600"
  depends_on      = [tls_private_key.this]
}

# Save public key locally.
resource "local_sensitive_file" "public_key" {
  count    = var.ssh_key_gen ? 1 : 0
  provider = local
  
  content    = tls_private_key.this[0].public_key_openssh
  filename   = var.public_key_name
  depends_on = [tls_private_key.this]
}
