resource "kubernetes_namespace" "argo-ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = local.default_password
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
  name  = "server.extraArgs"
  value = "{--insecure,--request-timeout=\"5m\"}"
  }

}


resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  values = [
    "${file("jenkins-values.yaml")}"
  ]

  set_sensitive {
    name  = "controller.adminUser"
    value = var.jenkins_admin_user
  }

  set_sensitive {
    name  = "controller.adminPassword"
    value = var.jenkins_admin_password
  }
}