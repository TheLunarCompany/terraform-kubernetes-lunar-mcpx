# Deploy Lunar MCPX in basic configuration

This example illustrates how to deploy Lunar MCPX to the Kubernetes cluster using the [terraform-kubernets-lunar-mcpx](..%2F..) module.

It will:
- Create a namespace `mcpx`
- Deploy Lunar MCPX in basic configuration with modified `app.yaml`, `mcp.json` configuration files

---

## Usage

To provision this example, run the following from within this directory:
- If necessary, modify default values in [variables.tf](variables.tf) or create terraform.tfvars to override `kubernetes_config_path` and/or `kubernetes_config_context` variables
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

---

## Requirements

#### Providers

| Name | Version |
|------|---------|
| kubernetes | 2.37.1 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kubernetes_config_context | Kubeconfig context | `string` | `"my-context"` | no |
| kubernetes_config_path | Path to the kubeconfig file | `string` | `"~/.kube/config"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| lunar_mcpx | Return output of module.lunar_mcpx |

