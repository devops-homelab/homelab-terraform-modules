variable "deploy_cert_manager" {
  description = "Deploy cert-manager Helm chart"
  type        = any
  default     = {}
}

variable "deploy_nginx_ingress" {
  description = "Deploy NGINX Ingress Helm chart"
  type        = any
  default     = {}
}
variable "deploy_argo_cd" {
  description = "Deploy of Argo CD"
  type        = any
  default     = {}
}