output "deployment_name" {
  description = "Name of the Kubernetes deployment"
  value       = kubernetes_deployment.mcpx.metadata[0].name
}

output "service_name" {
  description = "Name of the Kubernetes service"
  value       = kubernetes_service.mcpx.metadata[0].name
}

output "config_map_name" {
  description = "Name of the Kubernetes ConfigMap"
  value       = kubernetes_config_map.mcpx_config.metadata[0].name
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = var.namespace
}

output "service_port" {
  description = "Service port"
  value       = var.service_port
}

output "metrics_port" {
  description = "Metrics port (if enabled)"
  value       = var.metrics_enabled ? var.metrics_port : null
}