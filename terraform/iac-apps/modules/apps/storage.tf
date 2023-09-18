resource "kubernetes_manifest" "persistentvolume_my_pv" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolume"
    "metadata" = {
      "labels" = {
        "type" = "local"
      }
      "name" = "my-pv"
    }
    "spec" = {
      "accessModes" = [
        "ReadWriteMany",
      ]
      "capacity" = {
        "storage" = "512Mi"
      }
      "claimRef" = {
        "name" = "keria-pvc"
        "namespace" = "default"
      }
      "hostPath" = {
        "path" = "/data/keri"
      }
      "storageClassName" = "manual"
    }
  }
}

resource "kubernetes_manifest" "persistentvolumeclaim_keria_pvc" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolumeClaim"
    "metadata" = {
      "namespace" = "default"
      "name" = "keria-pvc"
    }
    "spec" = {
      "accessModes" = [
        "ReadWriteMany",
      ]
      "resources" = {
        "requests" = {
          "storage" = "512Mi"
        }
      }
      "volumeMode" = "Filesystem"
    }
  }

  depends_on = [
    kubernetes_manifest.persistentvolume_my_pv
  ]
}
