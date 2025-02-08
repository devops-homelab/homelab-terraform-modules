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
  version    = try(each.value.version, var.deploy_cert-manager.version, "")
  values     = [file("${path.module}/values/cert_manager_values.yaml")]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}