terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.63.3"
    }
    tls = {
      source = "hashicorp/tls"
      version = ">= 4.1.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.7.2"
    }
    local = {
      source = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}