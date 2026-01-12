module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "backend-cluster"
  cluster_version = "1.28"
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  enable_irsa = true 
  
  custom_oidc_thumbprints = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]

  eks_managed_node_groups = {
    main = {
      instance_types = ["t3.medium"]
      min_size     = 2
      max_size     = 5
    }
  }
}

resource "time_sleep" "wait_for_eks" {
  depends_on = [module.eks]
  create_duration = "90s"
}
