################################################################################
# Cert Manager
################################################################################
resource "helm_release" "cert-manager" {
  for_each = { for k, v in local.deploy_cert_manager : k => v }

  name       = "cert-manager"
  chart      = "cert-manager"
  atomic     = false
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
}

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
  values           = [file("${path.module}/values/ingress_nginx_values.yaml")]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}
