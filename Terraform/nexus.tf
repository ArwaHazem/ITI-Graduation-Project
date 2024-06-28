resource "kubernetes_deployment" "nexus" {
  metadata {
    name      = "nexus"
    namespace = kubernetes_namespace.tools.metadata[0].name

    labels = {
      app = "nexus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nexus"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }

      spec {
        container {
          name  = "nexus"
          image = "sonatype/nexus3:latest"

          port {
            name          = "nexus"
            container_port = 8081
          }

          port {
            name          = "docker"
            container_port = 5000
          }
          # volume_mount {
          #   name       = "nexus-home"
          #   mount_path = "/nexus-data"
          # }  

        }
        # volume {
        #   name = "nexus-home"
        #   empty_dir {}
        # }
        
      }
    }
  }
}


resource "kubernetes_service" "nexus" {
  metadata {
    name      = "nexus"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name = "http"
      port        = 8081
      target_port = 8081
    }
    port {
      name = "docker"
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "nexus2" {
  metadata {
    name      = "nexus"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name = "http"
      port        = 8081
      target_port = 8081
    }
    port {
      name = "docker"
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}