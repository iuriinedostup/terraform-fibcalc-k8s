data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = var.cluster_version
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  cluster_tags    = var.default_tags

  manage_cluster_iam_resources = false
  cluster_iam_role_name        = aws_iam_role.eks_cluster_role.name

  iam_path                        = "/iurii-eks-tf/"
  cluster_endpoint_private_access = false

  enable_irsa = true

  map_roles = [
    {
      rolearn  = var.deployment_role
      username = "{{SessionName}}"
      groups   = ["system:authenticated", "system:masters"]
    }
  ]

  worker_groups = [
    {
      name                          = "main-worker-group"
      instance_type                 = local.instance_type
      asg_desired_capacity          = "3"
      root_volume_size              = "8"
      additional_security_group_ids = [aws_security_group.worker_group_mnmt.id]
      health_check_type             = "EC2"
      key_name                      = aws_key_pair.key_pair.key_name
    }
  ]

  depends_on = [
    aws_iam_role.eks_cluster_role,
    module.vpc.vpc_id,
    module.vpc.private_subnets
  ]
}

locals {
  instance_type = "t2.small"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "vpc-cni"
  resolve_conflicts = "OVERWRITE"
  addon_version     = "v1.10.1-eksbuild.1"

  depends_on = [
    module.eks
  ]
}
