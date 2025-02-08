################################################################################
# Metrics Server
################################################################################
resource "helm_release" "metrics-server" {
  for_each = { for k, v in local.deploy_metrics-server : k => v }

  name       = "metrics-server"
  chart      = "metrics-server"
  atomic     = true
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  version    = try(each.value.version, var.deploy_metrics-server.version, "")
  values     = [file("${path.module}/helm_values/metrics_server_values.yaml")]

  dynamic "set" {
    for_each = try(each.value.additional_set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}