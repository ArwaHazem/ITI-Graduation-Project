resource "kubernetes_service_account" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "jenkins_role" {
  metadata {
    name = "Jenkins-Role"
  }

  rule {
    api_groups = [""]
    resources  = ["deployments"]
    verbs      = ["get", "watch", "list", "create"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "watch", "list", "create"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_role_binding" {
  metadata {
    name = "Jenkins-RoleBinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins.metadata[0].name
    namespace = kubernetes_service_account.jenkins.metadata[0].namespace
  }

  role_ref {
    kind     = "ClusterRole"
    name     = kubernetes_cluster_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "tools_role" {
  metadata {
    name = "Tools-Role"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["create", "get", "watch", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "tools_role_binding" {
  metadata {
    name = "Tools-RoleBinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  role_ref {
    kind     = "ClusterRole"
    name     = kubernetes_cluster_role.tools_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}