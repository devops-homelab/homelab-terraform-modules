################################################################################
# Gateway API Manifests for Infrastructure Services
################################################################################

################################################################################
# ArgoCD Gateway
################################################################################
resource "kubectl_manifest" "argocd_gateway" {
  for_each = { for k, v in local.deploy_argo_cd : k => v }

  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "argocd-gateway"
      namespace = "argocd"
      annotations = {
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      }
    }
    spec = {
      gatewayClassName = "cilium"
      listeners = [
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          hostname = "argocd.devopshomelab.live"
          tls = {
            mode = "Terminate"
            certificateRefs = [
              {
                kind = "Secret"
                name = "argocd-tls"
              }
            ]
          }
        }
      ]
    }
  })

  depends_on = [
    helm_release.argo-cd
  ]
}

resource "kubectl_manifest" "argocd_httproute" {
  for_each = { for k, v in local.deploy_argo_cd : k => v }

  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "argocd-route"
      namespace = "argocd"
    }
    spec = {
      parentRefs = [
        {
          name      = "argocd-gateway"
          namespace = "argocd"
        }
      ]
      hostnames = ["argocd.devopshomelab.live"]
      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]
          backendRefs = [
            {
              name = "argo-cd-argocd-server"
              port = 80
            }
          ]
        }
      ]
    }
  })

  depends_on = [kubectl_manifest.argocd_gateway]
}

resource "kubectl_manifest" "argocd_certificate" {
  for_each = { for k, v in local.deploy_argo_cd : k => v }

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "argocd-tls"
      namespace = "argocd"
    }
    spec = {
      secretName = "argocd-tls"
      issuerRef = {
        name = "letsencrypt-prod"
        kind = "ClusterIssuer"
      }
      dnsNames = ["argocd.devopshomelab.live"]
    }
  })

  depends_on = [
    helm_release.cert-manager,
    helm_release.argo-cd
  ]
}

################################################################################
# Argo Rollouts Gateway (if needed)
################################################################################
resource "kubectl_manifest" "argo_rollouts_gateway" {
  for_each = { for k, v in local.deploy_argo_rollouts : k => v if try(v.argo_rollouts_url, "") != "" }

  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "argo-rollouts-gateway"
      namespace = "argo-rollouts"
      annotations = {
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      }
    }
    spec = {
      gatewayClassName = "cilium"
      listeners = [
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          hostname = try(v.argo_rollouts_url, "")
          tls = {
            mode = "Terminate"
            certificateRefs = [
              {
                kind = "Secret"
                name = "argo-rollouts-tls"
              }
            ]
          }
        }
      ]
    }
  })

  depends_on = [
    helm_release.argo_rollouts
  ]
}
