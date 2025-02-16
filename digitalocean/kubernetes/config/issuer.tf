# Description: This file contains the terraform configuration to create the cert-manager issuer.

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  count = var.issuer_type.type == "cluster_issuer" ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.issuer_type.email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                ingressClassName = var.issuer_type.ingress_class
              }
            }
          }
        ]
      }
    }
  })

  depends_on = [helm_release.cert-manager]
}

resource "kubectl_manifest" "cert_manager_issuer" {
  count = var.issuer_type.type == "issuer" ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "letsencrypt-issuer"
      namespace = "default"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.issuer_type.email
        privateKeySecretRef = {
          name = "letsencrypt-issuer"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                ingressClassName = var.issuer_type.ingress_class
              }
            }
          }
        ]
      }
    }
  })

  depends_on = [helm_release.cert-manager]
}