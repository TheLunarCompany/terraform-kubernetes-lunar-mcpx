# Lunar MCPX Terraform Module

This Terraform module deploys the Lunar MCPX application onto a Kubernetes cluster, providing a straightforward, ready-to-use deployment solution.

## Installation

Clone the repository containing the Terraform modules and navigate to the `/lunar-mcpx` directory.

Once there, initialize and apply Terraform:

```bash
terraform init
terraform apply
```

## Usage Example

To customize deployment variables, including MCPX configuration files (`app.yaml`, `mcp.json`), create a `terraform.tfvars` file:

```hcl
namespace       = "mcpx"
mcp_json_config = <<-EOF
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=Europe/Berlin"]
    }
  }
}
EOF
```

Then run:

```bash
terraform apply
```

You may inspect the available variables in `variables.tf` to further customize your deployment.

## Variables

| Name               | Description                | Type     | Default                                                    |
| ------------------ | -------------------------- | -------- | ---------------------------------------------------------- |
| `name`             | Deployment name            | `string` | `"lunar-mcpx"`                                             |
| `namespace`        | Kubernetes namespace       | `string` | `"default"`                                                |
| `replica_count`    | Number of replicas         | `number` | `1`                                                        |
| `image_repository` | Container image repository | `string` | `"us-central1-docker.pkg.dev/prj-common-442813/mcpx/mcpx"` |
| `image_tag`        | Container image tag        | `string` | `"0.1.0"`                                                  |
| `service_type`     | Kubernetes service type    | `string` | `"LoadBalancer"`                                           |
| `service_port`     | Service port               | `number` | `9000`                                                     |
| `metrics_enabled`  | Enable metrics             | `bool`   | `true`                                                     |
| `metrics_port`     | Metrics port               | `number` | `3000`                                                     |
| `mcp_json_config`  | MCP JSON configuration     | `string` | See `variables.tf`                                         |
| `app_yaml_config`  | App YAML configuration     | `string` | See `variables.tf`                                         |

## Outputs

| Name              | Description                |
| ----------------- | -------------------------- |
| `deployment_name` | Kubernetes deployment name |
| `service_name`    | Kubernetes service name    |
| `configmap_name`  | Kubernetes configmap name  |
| `namespace`       | Kubernetes namespace       |
| `service_port`    | Service port               |
| `metrics_port`    | Metrics port (if enabled)  |

## Requirements

* Terraform >= 1.0
* Kubernetes provider \~> 2.0
* Configured Kubernetes cluster access

## Features

* Customizable readiness and liveness probes
* Optional metrics collection with Prometheus annotations
* Resource allocation controls (CPU/memory)
* External secrets via `secret_ref`
* Integration with control plane
* Optional Docker-in-Docker support
