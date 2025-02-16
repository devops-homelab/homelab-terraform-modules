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

variable "issuer_type" {
  description = "Choose between 'cluster_issuer' or 'issuer'"
  type        = string
  default     = "cluster_issuer"
  validation {
    condition     = contains(["cluster_issuer", "issuer", "none"], var.issuer_type)
    error_message = "Valid values for issuer_type are 'cluster_issuer', 'issuer', or 'none'."
  }
}

variable "email" {
  description = "Email for ACME registration"
  type        = string
}