resource "kubernetes_manifest" "serviceaccount_vlei" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "vlei"
    }
  }
}

resource "kubernetes_manifest" "deployment_vlei" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "vlei"
      }
      "name" = "vlei"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "vlei"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "vlei"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "aminbenmansour/vlei:1.0"
              "imagePullPolicy" = "Always"
              "name" = "vlei"
              "ports" = [
                {
                  "containerPort" = 7723
                },
              ]
            },
          ]
          "serviceAccountName" = "vlei"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_vlei" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "vlei"
      }
      "name" = "vlei"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http-vlei"
          "port" = 7723
          "targetPort" = 7723
        },
      ]
      "selector" = {
        "app" = "vlei"
      }
    }
  }
}
