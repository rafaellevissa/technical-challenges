resource "aws_iam_policy" "lbc_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Permite que o EKS gerencie ALBs e NLBs"
  policy      = file("${path.module}/lbc_iam_policy.json") 
}

module "lbc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.33.0"
  role_name = "eks-load-balancer-controller"

  role_policy_arns = {
    policy = aws_iam_policy.lbc_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  depends_on = [module.eks.time_sleep]
}