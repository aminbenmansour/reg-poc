resource "kubernetes_manifest" "application_argocd_webapp" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "annotations" = {
        "argocd-image-updater.argocd.argoproj.io/image-list" = "aminbenmansour/webapp:~1.0.4"
      }
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io",
      ]
      "name" = "webapp"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "default"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "chart" = "helm"
        "helm" = {
          "parameters" = [
            {
              "name" = "replicaCount"
              "value" = "2"
            },
            {
              "name" = "image.repository"
              "value" = "aminbenmansour/reg-poc"
            },
            {
              "name" = "image.tag"
              "value" = "1.0"
            },
          ]
        }
        "repoURL" = "https://github.com/aminbenmansour/reg-poc-webapp.git"
        "targetRevision" = "HEAD"
      }
      "syncPolicy" = {
        "automated" = {
          "allowEmpty" = false
          "prune" = true
          "selfHeal" = true
        }
        "syncOptions" = [
          "Validate=true",
          "CreateNamespace=true",
          "PrunePropagationPolicy=foreground",
          "PruneLast=true",
        ]
      }
    }
  }
}
