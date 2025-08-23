# Terraform version
terraform {
  required_version = ">= 1.6.3"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.66.0"
    }
  }
}