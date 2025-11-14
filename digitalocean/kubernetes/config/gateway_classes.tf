################################################################################
# Gateway API - Gateway Classes
################################################################################

################################################################################
# Kong GatewayClass for Gateway API (for ArgoCD and other GUIs)
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
      description    = "Kong Gateway API implementation for infrastructure services"
    }
  })

  depends_on = [helm_release.kong]
}

################################################################################
# Cilium GatewayClass (Managed by DigitalOcean)
################################################################################
# Note: Cilium and its GatewayClass are pre-installed and managed by DigitalOcean
# on DOKS clusters. No need to create or manage them via Terraform.
# Reference: https://www.digitalocean.com/community/tutorials/kubernetes-gateway-api-tutorial-cilium-ingress-alternative
