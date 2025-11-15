# resource "kubectl_manifest" "gateway_api" {
#   yaml_body = file("${path.module}/crd/gateway-api-standard-install.yaml")
# }

# resource "helm_release" "istio_base" {
#   chart            = "base"
#   create_namespace = true
#   name             = "istio-base"
#   namespace        = "istio-system"
#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   version          = "1.28.0"

#   set = [{
#     name  = "defaultRevision",
#     value = "default"
#   }]

#   depends_on = [kubectl_manifest.gateway_api]
# }

# resource "helm_release" "istiod" {
#   chart      = "istiod"
#   create_namespace = true
#   name       = "istiod"
#   namespace  = "istio-system"
#   repository = "https://istio-release.storage.googleapis.com/charts"
#   version    = "1.28.0"

#   depends_on = [helm_release.istio_base]
# }

# resource "helm_release" "istio_ingress" {
#   chart            = "gateway"
#   create_namespace = true
#   name             = "istio-ingress"
#   namespace        = "istio-ingress"
#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   version          = "1.28.0"

#   wait           = true
#   wait_for_jobs  = true
#   timeout        = 600  # 10 minutes

#   depends_on = [helm_release.istiod]
# }
