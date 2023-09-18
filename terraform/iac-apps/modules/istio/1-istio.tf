


# ==== HELM PROVIDER ==== (Not pulling for some reason: Time exceeded)
# # helm repo add istio https://istio-release.storage.googleapis.com/charts
# # helm repo update
# # helm install istio-base istio/base -n istio-system --set defaultRevision=default

# resource "helm_release" "istio_base" {
#   name = "istio-base"

#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   chart            = "base"
#   namespace        = "istio-ingress"
#   create_namespace = true
#   version          = "1.19.0"

#   set {
#     name  = "defaultRevision"
#     value = "default"
#   }
#   # values = [file("./modules/argocd/config/argocd.yaml")]
# }

# # helm install istiod istio/istiod --namespace istio-system

# resource "helm_release" "istiod" {
#   name = "istiod"

#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   chart            = "istiod"
#   namespace        = "istio-system"
#   create_namespace = true
#   version          = "1.9.0" # Adjust the version to the desired Istio version
# }

# # helm install istio-ingressgateway istio/gateway

# resource "helm_release" "istio_ingressgateway" {
#   name = "istio-ingressgateway"

#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   chart            = "gateway"
#   namespace        = "istio-ingress"
#   create_namespace = true
#   version          = "1.19.0"

#   # values = [file("./modules/argocd/config/argocd.yaml")]
# }