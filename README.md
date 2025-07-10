# Lunar MCPX Terraform Module

This Terraform module deploys the Lunar MCPX application onto a Kubernetes cluster, providing a straightforward, ready-to-use deployment solution.

---

## Usage
- To customize deployment variables, including MCPX configuration files (`app.yaml`, `mcp.json`), refer to [basic](basic) example.

---

## Features

* Customizable readiness and liveness probes
* Optional metrics collection with Prometheus annotations
* Resource allocation controls (CPU/memory)
* External secrets via `secret_ref`
* Integration with control plane
* Optional Docker-in-Docker support

---

## Requirements

#### Providers

| Name | Version |
|------|---------|
| kubernetes | >= 2.30 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_config | App configuration. Contents of this variable will be used to create 'app.yaml' configuration | `any` | <pre>{<br>  "auth": {<br>    "enabled": false<br>  },<br>  "permissions": {<br>    "base": "allow"<br>  },<br>  "toolExtensions": {<br>    "services": {}<br>  }<br>}</pre> | no |
| control_plane | Control plane configuration | <pre>object({<br>    host = string<br>    streaming = object({<br>      enabled = bool<br>    })<br>    rest = object({<br>      enabled = bool<br>    })<br>  })</pre> | <pre>{<br>  "host": "",<br>  "rest": {<br>    "enabled": false<br>  },<br>  "streaming": {<br>    "enabled": false<br>  }<br>}</pre> | no |
| docker_in_docker_enabled | Enable Docker-in-Docker | `bool` | `false` | no |
| healthcheck_path | Health check path | `string` | `"/healthcheck"` | no |
| image_pull_policy | Image pull policy | `string` | `"IfNotPresent"` | no |
| image_repository | Container image repository | `string` | `"us-central1-docker.pkg.dev/prj-common-442813/mcpx/mcpx"` | no |
| image_tag | Container image tag | `string` | `"0.1.6"` | no |
| liveness_probe | Liveness probe configuration | <pre>object({<br>    enabled               = bool<br>    initial_delay_seconds = number<br>    period_seconds        = number<br>    timeout_seconds       = number<br>    failure_threshold     = number<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 10,<br>  "timeout_seconds": 1<br>}</pre> | no |
| log_level | Log level | `string` | `"info"` | no |
| mcp_target_servers_config | MCP configuration. Contents of this variable will be used to create 'mcp.json' configuration | `any` | <pre>{<br>  "mcpServers": {<br>    "time": {<br>      "args": [<br>        "mcp-server-time",<br>        "--local-timezone=America/New_York"<br>      ],<br>      "command": "uvx"<br>    }<br>  }<br>}</pre> | no |
| metrics_enabled | Enable metrics collection | `bool` | `true` | no |
| metrics_port | Metrics port | `number` | `3000` | no |
| name | Name of the deployment | `string` | `"lunar-mcpx"` | no |
| namespace | Kubernetes namespace | `string` | `"default"` | no |
| readiness_probe | Readiness probe configuration | <pre>object({<br>    enabled               = bool<br>    initial_delay_seconds = number<br>    period_seconds        = number<br>    timeout_seconds       = number<br>    failure_threshold     = number<br>    success_threshold     = number<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 5,<br>  "success_threshold": 1,<br>  "timeout_seconds": 1<br>}</pre> | no |
| replica_count | Number of replicas | `number` | `1` | no |
| resources | Resource limits and requests | <pre>object({<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "limits": {<br>    "cpu": "500m",<br>    "memory": "264Mi"<br>  },<br>  "requests": {<br>    "cpu": "250m",<br>    "memory": "128Mi"<br>  }<br>}</pre> | no |
| secret_ref | Secret reference configuration | <pre>object({<br>    name = string<br>    keys = list(string)<br>  })</pre> | <pre>{<br>  "keys": [],<br>  "name": ""<br>}</pre> | no |
| service_port | Service port | `number` | `9000` | no |
| service_type | Kubernetes service type | `string` | `"LoadBalancer"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| config_map_name | Name of the Kubernetes ConfigMap |
| deployment_name | Name of the Kubernetes deployment |
| metrics_port | Metrics port (if enabled) |
| namespace | Kubernetes namespace |
| service_name | Name of the Kubernetes service |
| service_port | Service port |

