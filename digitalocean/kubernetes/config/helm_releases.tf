################################################################################
# Ingress Nginx
################################################################################
resource "helm_release" "ingress-nginx" {
  for_each = { for k, v in local.deploy_nginx_ingress : k => v }

  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  atomic           = true
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = try(each.value.version, var.deploy_nginx_ingress.version, "")
  timeout          = 600
  values           = [file("${path.module}/helm_values/ingress_nginx_values.yaml")]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}

################################################################################
# Cert Manager
################################################################################
resource "helm_release" "cert-manager" {
  for_each = { for k, v in local.deploy_cert_manager : k => v }

  name       = "cert-manager"
  chart      = "cert-manager"
  atomic     = true
  namespace  = "kube-system"
  repository = "https://charts.jetstack.io"
  version    = try(each.value.version, var.deploy_cert_manager.version, "")
  values     = [file("${path.module}/helm_values/cert_manager_values.yaml")]
  timeout    = 100

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  depends_on = [ helm_release.ingress-nginx ]
}

################################################################################
# ARGO CD
################################################################################
resource "helm_release" "argo-cd" {
  for_each = { for k, v in local.deploy_argo_cd : k => v }

  name             = "argo-cd"
  chart            = "argo-cd"
  atomic           = true
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  version          = try(each.value.version, var.deploy_argo_cd.version, "")
  values           = [templatefile("${path.module}/helm_values/argo_cd_values.yaml", {
    argocd_url        = try(each.value.argocd_url, var.deploy_argo_cd.argocd_url, "")
    pat_token         = try(each.value.pat_token, var.deploy_argo_cd.pat_token, "")
    git_username      = try(each.value.git_username, var.deploy_argo_cd.git_username, "")
    sso_client_id     = try(each.value.sso_client_id, var.deploy_argo_cd.sso_client_id, "")
    sso_client_secret = try(each.value.sso_client_secret, var.deploy_argo_cd.sso_client_secret, "")
  })]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  depends_on = [ helm_release.ingress-nginx, helm_release.cert-manager ]

}


################################################################################
# ARGO ROLLOUTS
################################################################################
resource "helm_release" "argo_rollouts" {
  for_each = { for k, v in local.deploy_argo_rollouts : k => v }

  name             = "argo-rollouts"
  chart            = "argo-rollouts"
  atomic           = true
  namespace        = "argo-rollouts"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  version          = try(each.value.version, var.deploy_argo_rollouts.version, "")
  values           = [templatefile("${path.module}/helm_values/argo_rollouts_values.yaml", {
    argo_rollouts_url = try(each.value.argo_rollouts_url, var.deploy_argo_rollouts.argo_rollouts_url, "")
  })]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  depends_on = [
    helm_release.ingress-nginx,
    helm_release.argo-cd,
    helm_release.cert-manager
  ]
}
