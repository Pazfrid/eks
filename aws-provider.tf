provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
  }
}


data "aws_eks_cluster" "aws_eks" {
  name = aws_eks_cluster.aws_eks.name
}
data "aws_eks_cluster_auth" "aws_eks_auth" {
  name = aws_eks_cluster.aws_eks.name
}




# provider "kubernetes" {
#   host                   = aws_eks_cluster.aws_eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.cluster_certificate_authority_data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.aws_eks.cluster_name]
#   }
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.aws_eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.cluster_certificate_authority_data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster_name]
#       command     = "aws"
#     }
#   }
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.aws_eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.aws_eks.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.aws_eks_auth.token
#   }
# }

# provider "kubernetes" {
#     host                   = aws_eks_cluster.aws_eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.aws_eks.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.aws_eks_auth.token
# }

# resource "helm_release" "httpbin" {
#   name       = "httpbin"
#   repository = "https://matheusfm.dev/charts"
#   chart      = "httpbin"

#   values = [
#     file("values.yaml")
#   ]
# }