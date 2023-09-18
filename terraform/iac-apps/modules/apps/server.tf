resource "kubernetes_manifest" "serviceaccount_server" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "server"
    }
  }
}

resource "kubernetes_manifest" "deployment_server" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "server"
      }
      "name" = "server"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "server"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "server"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "ENABLE_CORS"
                  "value" = "true"
                },
                {
                  "name" = "VERIFIER_AUTHORIZATIONS"
                  "value" = "http://verifier.default.svc.cluster.local/authorizations/"
                },
                {
                  "name" = "VERIFIER_PRESENTATIONS"
                  "value" = "http://verifier.default.svc.cluster.local/presentations/"
                },
                {
                  "name" = "VERIFIER_REPORTS"
                  "value" = "http://verifier.default.svc.cluster.local/reports/"
                },
                {
                  "name" = "VERIFIER_REQUESTS"
                  "value" = "http://verifier.default.svc.cluster.local/request/verify/"
                },
              ]
              "image" = "aminbenmansour/server:1.0"
              "imagePullPolicy" = "Always"
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 8000
                },
              ]
            },
          ]
          "serviceAccountName" = "server"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_server" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "server"
      }
      "name" = "server"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http-server"
          "port" = 8000
          "targetPort" = 8000
        },
      ]
      "selector" = {
        "app" = "server"
      }
    }
  }
}
