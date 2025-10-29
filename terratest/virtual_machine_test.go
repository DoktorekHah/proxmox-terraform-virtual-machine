package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVirtualMachineModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../../proxmox_env/micro_env/",
		Vars: map[string]interface{}{
			"name_vm":     "test",
			"description": "Test VM created by Terratest",
			"node_name":   "pve", // Replace with your actual node name
			"vm_id":       "1000",
			"cores":       1,
			"memory":      2048,
			"os_type":     "linux",
			"template_vm": true,
			"started":     false,
			"network_device": []map[string]interface{}{
				{
					"bridge":  "vmbr0",
					"model":   "virtio",
					"enabled": true,
				},
			},
			"disk": []map[string]interface{}{
				{
					"datastore_id": "test",
					"size":         "10G",
					"interface":    "scsi0",
					"cache":        "writeback",
					"file_format":  "raw",
				},
			},
			// "initialization": map[string]interface{}{
			// 	"datastore_id": "local-lvm",
			// 	"ip_config": map[string]interface{}{
			// 		"ipv4": map[string]interface{}{
			// 			"address": "dhcp",
			// 		},
			// 	},
			// 	"user_account": map[string]interface{}{
			// 		"username": "testuser",
			// 		"password": "testpass",
			// 	},
			// },
		},
		EnvVars: map[string]string{
			"PROXMOX_API_TOKEN_ID":     "root@pam!test-token",
			"PROXMOX_API_TOKEN_SECRET": "your-token-secret",
			"PROXMOX_API_URL":          "https://your-proxmox-host:8006/api2/json",
		},
	})

	// Clean up resources after the test
	defer terraform.Destroy(t, terraformOptions)

	// Run terraform init and apply
	terraform.InitAndApply(t, terraformOptions)

	// Get the VM ID from the output
	vmID := terraform.Output(t, terraformOptions, "vm_id")

	// Verify the VM was created successfully
	assert.NotEmpty(t, vmID, "VM ID should not be empty")

	// Add a small delay to allow for VM creation
	time.Sleep(10 * time.Second)

	// Verify VM properties
	vmName := terraform.Output(t, terraformOptions, "name")
	assert.Equal(t, "test-vm", vmName, "VM name should match")

	vmStatus := terraform.Output(t, terraformOptions, "status")
	assert.Equal(t, "stopped", vmStatus, "VM should be in stopped state")
}
