resource "kubernetes_manifest" "serviceaccount_witnesses" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "namespace" = "default"
      "name" = "witnesses"
    }
  }
}

resource "kubernetes_manifest" "deployment_witnesses" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "witnesses"
      }
      "name" = "witnesses"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "witnesses"
        }
      }
      "template" = {
        "metadata" = {
          "namespace" = "default"
          "labels" = {
            "app" = "witnesses"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "aminbenmansour/witnesses:1.0"
              "imagePullPolicy" = "Always"
              "name" = "witnesses"
              "ports" = [
                {
                  "containerPort" = 5632
                },
                {
                  "containerPort" = 5633
                },
                {
                  "containerPort" = 5634
                },
                {
                  "containerPort" = 5642
                },
                {
                  "containerPort" = 5643
                },
                {
                  "containerPort" = 5644
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
          "serviceAccountName" = "witnesses"
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

resource "kubernetes_manifest" "service_witnesses" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "namespace" = "default"
      "labels" = {
        "app" = "witnesses"
      }
      "name" = "witnesses"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "tcp-wan"
          "port" = 5632
          "targetPort" = 5632
        },
        {
          "name" = "tcp-wil"
          "port" = 5633
          "targetPort" = 5633
        },
        {
          "name" = "tcp-wes"
          "port" = 5634
          "targetPort" = 5634
        },
        {
          "name" = "http-wan"
          "port" = 5642
          "targetPort" = 5642
        },
        {
          "name" = "http-wil"
          "port" = 5643
          "targetPort" = 5643
        },
        {
          "name" = "http-wes"
          "port" = 5644
          "targetPort" = 5644
        },
      ]
      "selector" = {
        "app" = "witnesses"
      }
    }
  }
}
