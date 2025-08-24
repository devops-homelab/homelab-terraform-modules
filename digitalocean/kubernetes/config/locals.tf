locals {
  deploy_cert_manager            = var.deploy_cert_manager != null ? var.deploy_cert_manager : null
  deploy_nginx_ingress           = var.deploy_nginx_ingress != null ? var.deploy_nginx_ingress : null
  deploy_argo_cd                 = var.deploy_argo_cd != null ? var.deploy_argo_cd : null
  deploy_argo_rollouts           = var.deploy_argo_rollouts != null ? var.deploy_argo_rollouts : null
  deploy_kong                    = var.deploy_kong != null ? var.deploy_kong : null
  deploy_gateway_api             = var.deploy_gateway_api
}