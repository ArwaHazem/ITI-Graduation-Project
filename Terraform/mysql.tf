resource "kubernetes_service" "mysql_service" {
  metadata {
    name      = "mysql-h"
    namespace = kubernetes_namespace.dev.metadata[0].name
    labels = {
      app = "mysql"
    }
  }

  spec {
    port {
      port = 3306
      name = "mysql"
    }

    cluster_ip = "None"

    selector = {
      app = "mysql"
    }
  }
}

resource "kubernetes_stateful_set" "mysql_statefulset" {
  metadata {
    name      = "mysql-statefulset"
    namespace = kubernetes_namespace.dev.metadata[0].name
    labels = {
      app = "mysql"
    }
  }

  spec {
    service_name = kubernetes_service.mysql_service.metadata[0].name
    replicas     = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"

          port {
            container_port = 3306
            name           = "mysql"
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "mysql-root-password"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "database-name"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "password"
              }
            }
          }

          volume_mount {
            name      = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name      = "mysql-persistent-storage"
        namespace = kubernetes_namespace.dev.metadata[0].name
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}