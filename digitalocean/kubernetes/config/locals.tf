locals {
  deploy_cert_manager            = var.deploy_cert_manager != null ? var.deploy_cert_manager : null
  deploy_nginx_ingress           = var.deploy_nginx_ingress != null ? var.deploy_nginx_ingress : null
  deploy_argo_cd                   = var.deploy_argo_cd != null ? var.deploy_argo_cd : null
}