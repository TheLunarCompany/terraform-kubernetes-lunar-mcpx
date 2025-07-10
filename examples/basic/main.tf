resource "kubernetes_namespace" "lunar_mcpx" {
  metadata {
    name = "mcpx"
  }
}

module "lunar_mcpx" {
  source = "../../"

  namespace = kubernetes_namespace.lunar_mcpx.id

  mcp_config = {
    mcpServers = {
      time = {
        command = "uvx"
        args    = ["mcp-server-time", "--local-timezone=Europe/Berlin"]
      }
    }
  }

  app_config = {
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
