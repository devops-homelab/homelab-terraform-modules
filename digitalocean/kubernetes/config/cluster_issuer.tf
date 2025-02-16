resource "kubectl_manifest" "cluster_issuer_letsencrypt" {

  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "navindushane@gmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "ingressClassName" = "nginx"
              }
            }
          }
        ]
      }
    }
  })

  depends_on = [helm_release.cert_manager]
}
