terraform {
  required_providers {
    aws = {
        version = "4.21.0"
    }
    helm = {
        version = "2.6.0"
    }
    kubernetes = {
        version = "2.12.1"
    }
  }
  required_version = "~> 1.3.4"
}

provider "helm" {
    kubernetes {
        host                   = data.aws_eks_cluster.prod-cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.prod-cluster.certificate_authority.0.data)
            exec {
                api_version = "client.authentication.k8s.io/v1beta1"
                args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.prod-cluster.name]
                command     = "aws"
            }
    }
}


provider "kubernetes" {
    host                   = data.aws_eks_cluster.prod-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.prod-cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.prod-cluster.token
    #load_config_file       = false
}

provider "aws" {
    region = var.aws_region
    access_key = "AKIAY2BK7GGOPCZ5X7SM"
    secret_key = "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"
}