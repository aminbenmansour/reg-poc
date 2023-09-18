resource "kubernetes_manifest" "serviceaccount_webapp" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "webapp"
    }
  }
}

resource "kubernetes_manifest" "deployment_webapp" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "webapp"
      }
      "name" = "webapp"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "webapp"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "webapp"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "API_SERVICE_URL"
                  "value" = "http://server.default.svc.cluster.local"
                },
                {
                  "name" = "VERIFIER_SERVICE_URL"
                  "value" = "http://verifier.default.svc.cluster.local"
                },
                {
                  "name" = "VITE_SIGNIFY_URL"
                  "value" = "http://localhost:3901"
                },
                {
                  "name" = "VITE_SERVER_URL"
                  "value" = "http://server.default.svc.cluster.local:8000"
                },
              ]
              "image" = "aminbenmansour/webapp:1.0"
              "name" = "webapp"
              "ports" = [
                {
                  "containerPort" = 5173
                },
              ]
            },
          ]
          "serviceAccountName" = "webapp"
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

resource "kubernetes_manifest" "service_webapp" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "webapp"
      }
      "name" = "webapp"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 80
          "targetPort" = 5173
        },
      ]
      "selector" = {
        "app" = "webapp"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "gateway_webapp_gateway" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "Gateway"
    "metadata" = {
      "namespace" = "default"
      "name" = "webapp-gateway"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "*",
          ]
          "port" = {
            "name" = "http"
            "number" = 80
            "protocol" = "TCP"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "virtualservice_webapp" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "VirtualService"
    "metadata" = {
      "namespace" = "default"
      "name" = "webapp"
    }
    "spec" = {
      "gateways" = [
        "webapp-gateway",
      ]
      "hosts" = [
        "*",
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "webapp.default.svc.cluster.local"
                "port" = {
                  "number" = 80
                }
              }
            },
          ]
        },
      ]
    }
  }
}
