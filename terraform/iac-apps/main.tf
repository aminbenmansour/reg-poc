provider "helm" {
  alias = "default"
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  alias = "microk8s"
  config_path    = "~/.kube/config"
  config_context = "microk8s"
}

module "apps" {
  source = "./modules/apps"
  providers = {
    kubernetes = kubernetes.microk8s
  }
}

module "argocd" {
  source = "./modules/argocd"
  providers = {
    helm = helm.default
  }
}

module "istio" {
  source = "./modules/istio"
  providers = {
    helm = helm.default
    kubernetes = kubernetes.microk8s
  }
}


module "traefik" {
  source = "./modules/traefik"
  providers = {
    helm = helm.default
    kubernetes = kubernetes.microk8s
  }
}