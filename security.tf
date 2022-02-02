resource "aws_security_group" "worker_group_mnmt" {
  name_prefix = "iurii-eks-worker"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["10.0.0.0/20"]
  }
}