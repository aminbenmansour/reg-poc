

# ==== HELM PROVIDER ==== (Not pulling for some reason: Time exceeded)

# # helm repo add traefik https://traefik.github.io/charts
# # helm repo update
# # helm install traefik traefik/traefik

# resource "helm_release" "traefik" {
#   name = "traefik"

#   repository       = "https://traefik.github.io/traefik-helm-chart"
#   chart            = "traefik"
#   namespace        = "traefik-v2"
#   create_namespace = true
#   version          = "24.0.0"

#   # values = [file("config/traefik.yaml")]
# }