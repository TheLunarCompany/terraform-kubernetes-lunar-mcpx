resource "kubernetes_namespace" "lunar_mcpx" {
  metadata {
    name = "mcpx"
  }
}

module "lunar_mcpx" {
  source = "../../"

  namespace       = kubernetes_namespace.lunar_mcpx.id
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

  app_yaml_config = <<-EOT
auth:
  enabled: false
permissions:
  base: "allow"
toolExtensions:
  services: {}
EOT
}
