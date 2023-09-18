resource "kubernetes_manifest" "application_argocd_verifier" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "annotations" = {
        "argocd-image-updater.argocd.argoproj.io/image-list" = "aminbenmansour/verifier:~1.0.4"
      }
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io",
      ]
      "name" = "verifier"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "default"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "path" = "k8s"
        "repoURL" = "https://github.com/aminbenmansour/reg-poc-verifier.git"
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
