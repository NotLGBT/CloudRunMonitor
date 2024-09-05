# resource "helm_release" "chart1" {
#   name = "super-puper-release"
#   repository = "https://notlgbt.github.io/KuberResourceManifests/"
#   chart = "highreliable"
#   set {
#     name = "replicaCount"
#     value = 2
#   }
# }