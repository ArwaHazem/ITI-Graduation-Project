resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  type = "Opaque"

  data = {
    "database-name"      = "bXlkYXRhYmFzZQ=="
    "mysql-root-password" = "ZGIxMjM0NTY="
    "username"           = "YWRtaW4="
    "password"           = "YWRtaW4xMjM0NTY="
  }
}