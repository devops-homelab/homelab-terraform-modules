
# This file is responsible for creating the ArgoCD applications that will be used to bootstrap the cluster with the necessary applications.
resource "kubectl_manifest" "cluster_infra_bootstrap_app" {

  count = var.enable_cluster_bootstrap ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "cluster-bootstrap"
      namespace = "argocd"
    }
    spec = {
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      project = "default"
      source = {
        repoURL        = "https://github.com/devops-homelab/homelab-argo-app-config.git"
        targetRevision = "main"
        path           = "infra"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  })

  depends_on = [helm_release.argo-cd]
}

resource "kubectl_manifest" "application_root_app" {
  count = var.enable_application_bootstrap ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "application-bootstrap"
      namespace = "argocd"
    }
    spec = {
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      project = "default"
      source = {
        repoURL        = "https://github.com/devops-homelab/homelab-argo-app-config.git"
        targetRevision = "main"
        path           = "apps"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  })

  depends_on = [helm_release.argo-cd, kubectl_manifest.cluster_infra_bootstrap_app] 
}