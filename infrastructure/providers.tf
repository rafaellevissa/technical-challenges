data "aws_eks_cluster_auth" "cluster" {
  name = module.compute.cluster_name
}

terraform {
  required_version = ">= 1.5.0"
  
  /*
  backend "s3" {
    bucket         = "meu-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
  */

  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" }
    helm = { source = "hashicorp/helm", version = "~> 2.0" }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3             = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    rds            = "http://localhost:4566"
    eks            = "http://localhost:4566"
    cognitoidp    = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    batch          = "http://localhost:4566"
    iam            = "http://localhost:4566"
    route53        = "http://localhost:4566"
    cloudfront     = "http://localhost:4566"
    wafv2          = "http://localhost:4566"
    sts            = "http://localhost:4566"
    ecr            = "http://localhost:4566"
    kms            = "http://localhost:4566"
    logs           = "http://localhost:4566"
  }
}

provider "kubernetes" {
  host                   = module.compute.cluster_endpoint
  cluster_ca_certificate = base64decode(module.compute.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.compute.cluster_endpoint
    # cluster_ca_certificate = base64decode(module.compute.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    insecure = true

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "backend-cluster", "--endpoint-url", "http://localhost:4566"]
      command     = "aws"
    }
  }
}