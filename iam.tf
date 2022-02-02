resource "aws_iam_role" "eks_cluster_role" {
  name               = "iurii-eks-cluster-role-tf"
  path               = "/iurii-eks/"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role_policy.json
}

data "aws_iam_policy_document" "eks_cluster_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_management" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.id
}
