################################################################################
# Gateway API - Gateway Classes
################################################################################

################################################################################
# Kong GatewayClass for Gateway API
################################################################################
resource "kubectl_manifest" "kong_gatewayclass" {
  for_each = { for k, v in local.deploy_kong : k => v }
  
  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"
    metadata = {
      name = "kong"
      annotations = {
        "konghq.com/gatewayclass-unmanaged" = "true"
      }
    }
    spec = {
      controllerName = "konghq.com/kic-gateway-controller"
      description    = "Kong Gateway API implementation"
    }
  })

  depends_on = [helm_release.kong]
}
