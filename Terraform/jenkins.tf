
resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.tools.metadata[0].name

    labels = {
      app = "jenkins"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"

          port {
            container_port = 8080
          }
          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
          volume_mount {
            name       = "docker-socket"
            mount_path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "jenkins-home"
          empty_dir {}
        }

        volume {
          name = "docker-socket"
          host_path {
            path = "/var/run/docker.sock"
          }
        }
        
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  spec {
    selector = {
      app = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
      node_port   = 32000
    }

    type = "NodePort"
  }
}