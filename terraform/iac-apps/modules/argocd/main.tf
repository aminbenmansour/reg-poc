terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
    }
  }
}


provider "kubernetes" {
  alias = "microk8s"
  config_path    = "~/.kube/config"
  config_context = "microk8s"
}

module "argocd_jobs" {
  source = "./jobs"
  providers = {
    kubernetes = kubernetes.microk8s
  }
}