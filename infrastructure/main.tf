# Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
terraform {
  required_version = ">= 1.10.4"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# DigitalOcean does not currently support the concept of service principals or app registrations like Azure. Instead, it uses API tokens for authentication. 
provider "digitalocean" {
  token = var.DO_TOKEN
}
