variable "default_tags" {
  default = {
    Author  = "Iurii"
    Project = "Multi EKS Test"
  }
}

variable "cluster_version" {
  default = "1.21"
}

variable "cluster_name" {
  default = "iurii-eks-test"
}

variable "ssh_keypair" {
  default = "iurii_keypair"
}

variable "deployment_role" {
  type = string
}