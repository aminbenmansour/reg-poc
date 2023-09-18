resource "kubernetes_manifest" "serviceaccount_verifier" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "verifier"
    }
  }
}

resource "kubernetes_manifest" "deployment_verifier" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "verifier"
      }
      "name" = "verifier"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "verifier"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "verifier"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "aminbenmansour/verifier:1.0"
              "imagePullPolicy" = "Always"
              "name" = "verifier"
              "ports" = [
                {
                  "containerPort" = 7676
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/usr/local/var/keri/"
                  "name" = "keri-data"
                },
              ]
            },
          ]
          "serviceAccountName" = "verifier"
          "volumes" = [
            {
              "name" = "keri-data"
              "persistentVolumeClaim" = {
                "claimName" = "keria-pvc"
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_verifier" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "verifier"
      }
      "name" = "verifier"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http-verifier"
          "port" = 7676
          "targetPort" = 7676
        },
      ]
      "selector" = {
        "app" = "verifier"
      }
    }
  }
}
