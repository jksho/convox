terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  required_version = ">= 0.12"
}
