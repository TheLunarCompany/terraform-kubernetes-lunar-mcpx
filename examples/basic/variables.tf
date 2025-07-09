variable "kubernetes_config_path" {
  type        = string
  default     = "~/.kube/config"
  description = "Path to the kubeconfig file"
}

variable "kubernetes_config_context" {
  type        = string
  default     = "my-context"
  description = "Kubeconfig context"
}