# Proxmox Virtual Machine Terraform Module

A comprehensive Terraform/OpenTofu module for managing Proxmox virtual machines with integrated security scanning (Checkov) and code linting (TFLint). This module supports both Terraform and OpenTofu through a unified Makefile.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-623CE4)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.0-FFDA18)](https://opentofu.org/)

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Makefile Commands](#-makefile-commands)
- [Security & Linting](#-security--linting)
- [Testing](#-testing)
- [Module Reference](#-module-reference)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Core Capabilities
- **Dual Tool Support**: Works with both Terraform and OpenTofu
- **VM Management**: Complete virtual machine lifecycle management on Proxmox VE
- **Cloud-Init Integration**: Automated VM provisioning with cloud-init
- **SSH Key Management**: Automated SSH key generation and deployment
- **Flexible Configuration**: UEFI/BIOS, TPM, dynamic disk and network configuration

### Security & Quality
- **Security Scanning**: Integrated Checkov for IaC security analysis
- **Code Linting**: TFLint for Terraform/OpenTofu code quality
- **CI/CD Ready**: Pre-configured pipelines for both Terraform and OpenTofu
- **Best Practices**: Follows Terraform/OpenTofu module best practices

### Advanced Features
- **UEFI/BIOS Support**: Configure either BIOS mode
- **TPM State**: TPM 2.0 support for secure boot
- **Dynamic Disk Configuration**: Flexible disk management with multiple interfaces
- **Network Management**: Multiple network interfaces with VLAN support
- **Serial Console**: Serial device configuration for debugging
- **USB Passthrough**: USB device mapping support
- **Template Creation**: Create VM templates for rapid deployment

## 🔧 Prerequisites

### Required Tools
- **Terraform** >= 1.6.0 OR **OpenTofu** >= 1.0
- **Python** >= 3.8 (for Checkov security scanning)
- **TFLint** (automatically installed via Makefile)
- **Proxmox VE** cluster with API access

### Optional Tools
- **Go** >= 1.19 (for Terratest integration tests)
- **pipx** or **pip3** (for Checkov installation)

### Provider Requirements
- `bpg/proxmox` >= 0.63.3
- `hashicorp/local` >= 2.4.0
- `hashicorp/random` >= 3.7.2
- `hashicorp/tls` >= 4.1.0

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install all dependencies (Checkov + TFLint)
make install

# Or install individually
make checkov-install
make tflint-install
```

### 2. Initialize TFLint

```bash
# Initialize TFLint plugins (required once)
make tflint-init
```

### 3. Choose Your Tool

#### Using Terraform:
```bash
# Initialize Terraform
make terraform-init

# Validate configuration
make terraform-validate

# Preview changes
make terraform-plan

# Apply changes
make terraform-apply
```

#### Using OpenTofu:
```bash
# Initialize OpenTofu
make tofu-init

# Validate configuration
make tofu-validate

# Preview changes
make tofu-plan

# Apply changes
make tofu-apply
```

### 4. Run Security & Quality Checks

```bash
# Run all checks
make test-all

# Or run individually
make checkov-scan    # Security scan
make tflint-check    # Code linting
```

## 💻 Usage

### Basic VM Configuration

```hcl
module "vm" {
  source = "github.com/your-org/proxmox-terraform-virtual-machine"

  # Basic Configuration
  name_vm    = "my-vm"
  node_name  = "pve01"
  vm_id      = 100
  
  # Hardware
  cores      = 2
  memory     = 4096
  bios       = "ovmf"
  
  # OS Configuration
  username       = "admin"
  ssh_key_gen    = true
  started        = true
  
  # Tags
  tags = ["production", "web-server"]
  
  # Disk Configuration
  disk = {
    os = {
      cache        = "none"
      datastore_id = "local-lvm"
      file_format  = "qcow2"
      file_id      = "local:iso/ubuntu-22.04.img"
      interface    = "virtio0"
      size         = "32"
    }
  }

  # Network Configuration
  network_device = {
    lan0 = {
      bridge  = "vmbr0"
      vlan_id = 0 
      enabled = true
     }
  }
}
```

### Advanced Configuration with Multiple Disks

```hcl
module "vm_advanced" {
  source = "github.com/your-org/proxmox-terraform-virtual-machine"

  name_vm   = "advanced-vm"
  node_name = "pve01"
  vm_id     = 101
  
  cores     = 4
  memory    = 8192
  bios      = "ovmf"
  
  # Multiple Disks
  disk = {
    os = {
      cache        = "none"
      datastore_id = "local-lvm"
      file_format  = "qcow2"
      interface    = "virtio0"
      size         = "50"
      ssd          = true
      iothread     = true
    }
    data = {
      cache        = "none"
      datastore_id = "local-lvm"
      file_format  = "qcow2"
      interface    = "virtio1"
      size         = "100"
      ssd          = true
    }
  }
  
  # Multiple Network Interfaces
  network_device = {
    lan0 = {
      bridge  = "vmbr0"
      vlan_id = 10
      enabled = true
    }
    lan1 = {
      bridge  = "vmbr1"
      vlan_id = 20
      enabled = true
    }
  }

  # TPM Configuration
  tpm_state = {
    tpm = {
      version      = "v2.0"
      datastore_id = "local-lvm"
    }
  }
  
  # Cloud-init
  user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
}
```

### Template VM Creation

```hcl
module "vm_template" {
  source = "github.com/your-org/proxmox-terraform-virtual-machine"

  name_vm     = "ubuntu-template"
  node_name   = "pve01"
  vm_id       = 9000
  template_vm = true
  started     = false
  
  cores  = 2
  memory = 2048
  
  disk = {
    os = {
      datastore_id = "local-lvm"
      file_id      = "local:iso/ubuntu-22.04-cloud.img"
      interface    = "virtio0"
      size         = "20"
    }
  }
  
  tags = ["template", "ubuntu"]
}
```

## 📋 Makefile Commands

### Installation & Setup

```bash
make install              # Install all dependencies (Checkov + TFLint)
make checkov-install      # Install Checkov security scanner
make tflint-install       # Install TFLint linter
make tflint-init          # Initialize TFLint plugins
make dev-setup            # Set up complete development environment
```

### Security Scanning (Checkov)

```bash
make checkov-scan         # Run Checkov security scan
make checkov-scan-json    # Run scan with JSON output
make checkov-scan-sarif   # Run scan with SARIF output (CI/CD)
make test-security        # Run security tests only
```

### Code Linting (TFLint)

```bash
make tflint-init          # Initialize TFLint plugins
make tflint-check         # Run TFLint code quality checks
make test-lint            # Run linting tests only
```

### Terraform Commands

```bash
make terraform-init       # Initialize Terraform
make terraform-validate   # Validate Terraform configuration
make terraform-plan       # Create execution plan
make terraform-plan-out   # Create and save execution plan
make terraform-apply      # Apply configuration
make terraform-apply-plan # Apply saved plan
make terraform-destroy    # Destroy infrastructure
make terraform-format     # Format Terraform files
```

### OpenTofu Commands

```bash
make tofu-init            # Initialize OpenTofu
make tofu-validate        # Validate OpenTofu configuration
make tofu-plan            # Create execution plan
make tofu-plan-out        # Create and save execution plan
make tofu-apply           # Apply configuration
make tofu-apply-plan      # Apply saved plan
make tofu-destroy         # Destroy infrastructure
make tofu-format          # Format OpenTofu files
```

### Testing Commands

```bash
make test                 # Run complete test workflow (validate + lint + plan)
make test-all             # Run all tests (security + linting + workflow)
make test-lint            # Run linting tests only
make test-security        # Run security tests only
make test-go              # Run Go-based Terratest integration tests
```

### CI/CD Commands

```bash
make ci                   # Run CI pipeline (security + lint + terraform workflow)
```

### Utility Commands

```bash
make clean                # Clean up generated files
make clean-all            # Clean up all files including state
make help                 # Show all available commands
make docs                 # Display module documentation
```

## 🔒 Security & Linting

### Checkov Security Scanning

This module includes integrated security scanning using [Checkov](https://www.checkov.io/) to ensure your infrastructure code follows security best practices.

**Key Features:**
- 🛡️ Security misconfiguration detection
- ✅ Compliance framework validation
- 📊 Multiple output formats (CLI, JSON, SARIF)
- 🔌 CI/CD integration ready
- 📝 Custom policy support

**Configuration:** `.checkov.yml`

```yaml
framework:
  - terraform

output:
  - cli
  - json
  - sarif

skip-download: true
```

**Usage:**
```bash
# Run security scan
make checkov-scan

# Generate JSON report
make checkov-scan-json

# Generate SARIF report for CI/CD
make checkov-scan-sarif
```

### TFLint Code Quality

TFLint checks your Terraform/OpenTofu code for errors, deprecated syntax, and best practices.

**Key Features:**
- 🔍 Syntax and logic error detection
- 📏 Best practice enforcement
- 🎯 Provider-specific rule sets
- 🔄 Naming convention validation
- 📚 Module version checking

**Configuration:** `.tflint.hcl`

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_naming_convention" {
  enabled = true
}
```

**Usage:**
```bash
# Initialize TFLint (once)
make tflint-init

# Run code quality checks
make tflint-check
```

### Security Best Practices

1. **Always scan before deploy:**
   ```bash
   make checkov-scan && make tflint-check
   ```

2. **Review scan results:**
   - Address all **Failed** checks
   - Understand **Skipped** checks
   - Document exceptions

3. **Integrate into CI/CD:**
   ```bash
   make ci  # Runs security + linting + validation
   ```

## 🧪 Testing

### Quick Test Workflows

```bash
# Run complete test workflow (recommended)
make test-all

# Test Terraform workflow only
make test

# Test security and linting only
make test-security
make test-lint
```

### CI/CD Pipeline

The `ci` target runs a complete pipeline suitable for CI/CD:

```bash
make ci
```

This executes:
1. Checkov security scan
2. TFLint initialization
3. TFLint code quality check
4. Terraform/OpenTofu initialization
5. Configuration validation
6. Execution plan generation

### Integration Tests

For Go-based integration tests using Terratest:

```bash
make test-go
```

### Manual Testing

```bash
# 1. Initialize
make terraform-init

# 2. Validate syntax
make terraform-validate

# 3. Check code quality
make tflint-check

# 4. Security scan
make checkov-scan

# 5. Preview changes
make terraform-plan

# 6. Apply (with approval)
make terraform-apply
```

## 📚 Module Reference

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_local"></a> [local](#requirement_local) | >= 2.4.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement_proxmox) | >= 0.63.3 |
| <a name="requirement_random"></a> [random](#requirement_random) | >= 3.7.2 |
| <a name="requirement_tls"></a> [tls](#requirement_tls) | >= 4.1.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider_local) | >= 2.4.0 |
| <a name="provider_proxmox"></a> [proxmox](#provider_proxmox) | >= 0.63.3 |
| <a name="provider_random"></a> [random](#provider_random) | >= 3.7.2 |
| <a name="provider_tls"></a> [tls](#provider_tls) | >= 4.1.0 |

### Resources

| Name | Type |
|------|------|
| [local_sensitive_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [proxmox_virtual_environment_file.source_file](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_file.source_raw](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

### Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_node_name"></a> [node_name](#input_node_name) | The name of the Proxmox node to create the VM on | `string` | yes |
| <a name="input_name_vm"></a> [name_vm](#input_name_vm) | The name of the VM | `string` | no |
| <a name="input_vm_id"></a> [vm_id](#input_vm_id) | The ID of the VM | `number` | no |
| <a name="input_cores"></a> [cores](#input_cores) | The number of CPU cores | `number` | no |
| <a name="input_memory"></a> [memory](#input_memory) | The amount of memory in MB | `number` | no |
| <a name="input_bios"></a> [bios](#input_bios) | The BIOS type (seabios or ovmf) | `string` | no |
| <a name="input_disk"></a> [disk](#input_disk) | The disk configuration for the VM | `map(object)` | no |
| <a name="input_network_device_bridge"></a> [network_device_bridge](#input_network_device_bridge) | The network device configuration | `map(object)` | no |
| <a name="input_tags"></a> [tags](#input_tags) | The tags to apply to the VM | `list(string)` | no |
| <a name="input_ssh_key_gen"></a> [ssh_key_gen](#input_ssh_key_gen) | Whether to generate SSH keys automatically | `bool` | no |
| <a name="input_ssh_public_key"></a> [ssh_public_key](#input_ssh_public_key) | The SSH public key for the VM | `string` | no |
| <a name="input_started"></a> [started](#input_started) | Whether to start the VM after creation | `bool` | no |
| <a name="input_template_vm"></a> [template_vm](#input_template_vm) | Whether to create the VM as a template | `bool` | no |
| <a name="input_tpm_state"></a> [tpm_state](#input_tpm_state) | The TPM state configuration for the VM | `map(object)` | no |

*For complete input reference, see [variables.tf](variables.tf)*

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_outputs_vm"></a> [outputs_vm](#output_outputs_vm) | VM ID and name |
| <a name="output_env_files"></a> [env_files](#output_env_files) | Environment files information |
<!-- END_TF_DOCS -->

## 🛠️ Development

### Setting Up Development Environment

```bash
# Complete setup
make dev-setup

# This will:
# - Install Checkov
# - Install TFLint
# - Initialize TFLint plugins
```

### Code Quality

```bash
# Format code
make terraform-format  # or make tofu-format

# Validate configuration
make terraform-validate  # or make tofu-validate

# Run linting
make tflint-check

# Run security scan
make checkov-scan
```

### Development Workflow

1. **Make Changes**
   ```bash
   # Edit your .tf files
   vim main.tf
   ```

2. **Format Code**
   ```bash
   make terraform-format
   ```

3. **Validate & Lint**
   ```bash
   make terraform-validate
   make tflint-check
   ```

4. **Security Scan**
   ```bash
   make checkov-scan
   ```

5. **Test**
   ```bash
   make terraform-plan
   ```

6. **Clean Up**
   ```bash
   make clean
   ```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
make terraform-plan

# Enable OpenTofu debug logging
export TF_LOG=DEBUG
make tofu-plan

# Clean up everything and start fresh
make clean-all
make terraform-init
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Before Contributing

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow Terraform/OpenTofu best practices
   - Update documentation
   - Add tests if applicable

4. **Run quality checks**
   ```bash
   make terraform-format
   make tflint-check
   make checkov-scan
   make test-all
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "feat: add new feature"
   ```

6. **Submit a pull request**

### Development Guidelines

- ✅ Always run `make checkov-scan` before committing
- ✅ Ensure all tests pass with `make test-all`
- ✅ Follow semantic versioning
- ✅ Update README for new features
- ✅ Add examples for new functionality
- ✅ Document any breaking changes

### Code Style

- Use descriptive variable names
- Add comments for complex logic
- Keep functions small and focused
- Follow the existing code structure

## 📖 Additional Resources

### Documentation
- [Proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/language/modules/develop)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)

### Community
- [Proxmox Forum](https://forum.proxmox.com/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core)
- [OpenTofu Community](https://opentofu.org/community/)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/your-org/repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/repo/discussions)
- **Security**: Report security issues privately to security@your-org.com

## 🙏 Acknowledgments

- [BPG Proxmox Provider](https://github.com/bpg/terraform-provider-proxmox) - Excellent Proxmox provider
- [Checkov](https://www.checkov.io/) - Infrastructure security scanning
- [TFLint](https://github.com/terraform-linters/tflint) - Terraform linting

---

**⚠️ Important Notes:**

- Always review security scan results before deploying to production
- Test changes in a development environment first
- Keep your Proxmox API credentials secure
- Regularly update providers and tools to latest versions
- Back up your Terraform/OpenTofu state files

**Made with ❤️ for the Proxmox and Terraform/OpenTofu community**
