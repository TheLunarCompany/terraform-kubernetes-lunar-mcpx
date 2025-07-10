variable "name" {
  description = "Name of the deployment"
  type        = string
  default     = "lunar-mcpx"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "us-central1-docker.pkg.dev/prj-common-442813/mcpx/mcpx"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "0.1.6"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = 9000
}

variable "resources" {
  description = "Resource limits and requests"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "500m"
      memory = "264Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "128Mi"
    }
  }
}

variable "healthcheck_path" {
  description = "Health check path"
  type        = string
  default     = "/healthcheck"
}

variable "readiness_probe" {
  description = "Readiness probe configuration"
  type = object({
    enabled               = bool
    initial_delay_seconds = number
    period_seconds        = number
    timeout_seconds       = number
    failure_threshold     = number
    success_threshold     = number
  })
  default = {
    enabled               = true
    initial_delay_seconds = 5
    period_seconds        = 5
    timeout_seconds       = 1
    failure_threshold     = 3
    success_threshold     = 1
  }
}

variable "liveness_probe" {
  description = "Liveness probe configuration"
  type = object({
    enabled               = bool
    initial_delay_seconds = number
    period_seconds        = number
    timeout_seconds       = number
    failure_threshold     = number
  })
  default = {
    enabled               = true
    initial_delay_seconds = 10
    period_seconds        = 10
    timeout_seconds       = 1
    failure_threshold     = 3
  }
}

variable "log_level" {
  description = "Log level"
  type        = string
  default     = "info"
}

variable "metrics_enabled" {
  description = "Enable metrics collection"
  type        = bool
  default     = true
}

variable "metrics_port" {
  description = "Metrics port"
  type        = number
  default     = 3000
}

variable "docker_in_docker_enabled" {
  description = "Enable Docker-in-Docker"
  type        = bool
  default     = false
}

variable "mcp_target_servers_config" {
  description = "MCP configuration. Contents of this variable will be used to create 'mcp.json' configuration"
  type        = any
  default = {
    mcpServers = {
      time = {
        command = "uvx"
        args    = ["mcp-server-time", "--local-timezone=America/New_York"]
      }
    }
  }
}

variable "app_config" {
  description = "App configuration. Contents of this variable will be used to create 'app.yaml' configuration"
  type        = any
  default = {
    auth = {
      enabled = false
    }
    permissions = {
      base = "allow"
    }
    toolExtensions = {
      services = {}
    }
  }
}

variable "secret_ref" {
  description = "Secret reference configuration"
  type = object({
    name = string
    keys = list(string)
  })
  default = {
    name = ""
    keys = []
  }
}

variable "control_plane" {
  description = "Control plane configuration"
  type = object({
    host = string
    streaming = object({
      enabled = bool
    })
    rest = object({
      enabled = bool
    })
  })
  default = {
    host = ""
    streaming = {
      enabled = false
    }
    rest = {
      enabled = false
    }
  }
}
