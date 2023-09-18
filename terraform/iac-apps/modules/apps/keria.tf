resource "kubernetes_manifest" "serviceaccount_keria" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "keria"
    }
  }
}

resource "kubernetes_manifest" "deployment_keria" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "keria"
      }
      "name" = "keria"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "keria"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "keria"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "aminbenmansour/keria:1.0"
              "name" = "keria"
              "ports" = [
                {
                  "containerPort" = 3901
                },
                {
                  "containerPort" = 3902
                },
                {
                  "containerPort" = 3903
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/usr/local/var/keri/"
                  "name" = "data"
                },
              ]
            },
          ]
          "serviceAccountName" = "keria"
          "volumes" = [
            {
              "name" = "data"
              "persistentVolumeClaim" = {
                "claimName" = "keria-pvc"
              }
            },
          ]
        }
      }
    }
  }
  
  depends_on = [
    kubernetes_manifest.persistentvolumeclaim_keria_pvc
  ]
}

resource "kubernetes_manifest" "service_keria" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "keria"
      }
      "name" = "keria"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http-admin"
          "port" = 3901
          "targetPort" = 3901
        },
        {
          "name" = "http-http"
          "port" = 3902
          "targetPort" = 3902
        },
        {
          "name" = "http-boot"
          "port" = 3903
          "targetPort" = 3903
        },
      ]
      "selector" = {
        "app" = "keria"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "gateway_keria_gateway" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "Gateway"
    "metadata" = {
      "namespace" = "default"
      "name" = "keria-gateway"
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
            "name" = "http-admin"
            "number" = 3901
            "protocol" = "HTTP"
          }
        },
        {
          "hosts" = [
            "*",
          ]
          "port" = {
            "name" = "http-http"
            "number" = 3902
            "protocol" = "HTTP"
          }
        },
        {
          "hosts" = [
            "*",
          ]
          "port" = {
            "name" = "http-boot"
            "number" = 3903
            "protocol" = "HTTP"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "virtualservice_keria" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "VirtualService"
    "metadata" = {
      "namespace" = "default"
      "name" = "keria"
    }
    "spec" = {
      "gateways" = [
        "keria-gateway",
      ]
      "hosts" = [
        "*",
      ]
      "http" = [
        {
          "match" = [
            {
              "port" = 3901
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "keria.default.svc.cluster.local"
                "port" = {
                  "number" = 3901
                }
              }
            },
          ]
        },
        {
          "match" = [
            {
              "port" = 3902
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "keria.default.svc.cluster.local"
                "port" = {
                  "number" = 3902
                }
              }
            },
          ]
        },
        {
          "match" = [
            {
              "port" = 3903
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "keria.default.svc.cluster.local"
                "port" = {
                  "number" = 3903
                }
              }
            },
          ]
        },
      ]
    }
  }
}
