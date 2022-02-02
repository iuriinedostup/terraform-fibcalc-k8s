module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "iurii-dev-vpc"
  cidr = "10.0.0.0/20"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.10.0/24", "10.0.12.0/24", "10.0.14.0/24"]


  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
