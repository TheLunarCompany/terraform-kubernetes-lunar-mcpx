resource "kubernetes_config_map" "mcpx_config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
  }

  data = {
    "mcp.json" = jsonencode(var.mcp_config)
    "app.yaml" = yamlencode(var.app_config)
  }
}

resource "kubernetes_deployment" "mcpx" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
        annotations = {
          configmap-hash = sha256(jsonencode(kubernetes_config_map.mcpx_config.data))
        }
      }

      spec {
        container {
          name              = "mcpx"
          image             = "${var.image_repository}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          port {
            container_port = 9000
          }

          dynamic "readiness_probe" {
            for_each = var.readiness_probe.enabled ? [1] : []
            content {
              http_get {
                path = var.healthcheck_path
                port = 9000
              }
              initial_delay_seconds = var.readiness_probe.initial_delay_seconds
              period_seconds        = var.readiness_probe.period_seconds
              timeout_seconds       = var.readiness_probe.timeout_seconds
              failure_threshold     = var.readiness_probe.failure_threshold
              success_threshold     = var.readiness_probe.success_threshold
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe.enabled ? [1] : []
            content {
              http_get {
                path = var.healthcheck_path
                port = 9000
              }
              initial_delay_seconds = var.liveness_probe.initial_delay_seconds
              period_seconds        = var.liveness_probe.period_seconds
              timeout_seconds       = var.liveness_probe.timeout_seconds
              failure_threshold     = var.liveness_probe.failure_threshold
            }
          }

          resources {
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
          }

          volume_mount {
            name       = "mcp-config-vol"
            mount_path = "/etc/lunar-mcpx"
            read_only  = true
          }

          env {
            name  = "SERVERS_CONFIG_PATH"
            value = "/etc/lunar-mcpx/mcp.json"
          }

          env {
            name  = "APP_CONFIG_PATH"
            value = "/etc/lunar-mcpx/app.yaml"
          }

          env {
            name  = "LOG_LEVEL"
            value = var.log_level
          }

          env {
            name  = "ENABLE_METRICS"
            value = tostring(var.metrics_enabled)
          }

          env {
            name  = "SERVE_METRICS_PORT"
            value = tostring(var.metrics_port)
          }

          env {
            name  = "DIND_ENABLED"
            value = tostring(var.docker_in_docker_enabled)
          }

          env {
            name  = "ENABLE_CONTROL_PLANE_STREAMING"
            value = tostring(var.control_plane.streaming.enabled)
          }

          env {
            name  = "ENABLE_CONTROL_PLANE_REST"
            value = tostring(var.control_plane.rest.enabled)
          }

          env {
            name  = "CONTROL_PLANE_HOST"
            value = var.control_plane.host
          }

          dynamic "env" {
            for_each = var.secret_ref.name != "" ? var.secret_ref.keys : []
            content {
              name = env.value
              value_from {
                secret_key_ref {
                  name = var.secret_ref.name
                  key  = env.value
                }
              }
            }
          }
        }

        volume {
          name = "mcp-config-vol"
          config_map {
            name = kubernetes_config_map.mcpx_config.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mcpx" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
    annotations = var.metrics_enabled ? {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = tostring(var.metrics_port)
    } : {}
  }

  spec {
    type = var.service_type
    selector = {
      app = var.name
    }

    port {
      name        = "http"
      port        = var.service_port
      target_port = 9000
    }

    dynamic "port" {
      for_each = var.metrics_enabled ? [1] : []
      content {
        name        = "metrics"
        port        = var.metrics_port
        target_port = var.metrics_port
      }
    }
  }
}
