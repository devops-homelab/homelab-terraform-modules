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
  description = "Configuration for cert-manager issuer"
  type = object({
    type          = string    # "cluster_issuer", "issuer", "none"
    email         = string    # Email for ACME registration
    ingress_class = string    # Ingress class (e.g., "nginx")
  })
  default = {
    type          = "none"
    email         = ""
    ingress_class = "nginx"
  }
  validation {
    condition     = contains(["cluster_issuer", "issuer", "none"], var.issuer_type.type)
    error_message = "Valid issuer types are 'cluster_issuer', 'issuer', or 'none'."
  }
}

variable "enable_cluster_bootstrap" {
  description = "Enable the cluster bootstrap application"
  type        = bool
  default     = false
}

variable "enable_application_bootstrap" {
  description = "Enable the application bootstrap application"
  type        = bool
  default     = false
  
}