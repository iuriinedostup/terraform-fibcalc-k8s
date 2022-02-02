resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  public_key = tls_private_key.ssh_key_pair.public_key_openssh
  key_name   = var.ssh_keypair
}

resource "local_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${var.ssh_keypair}.pem")
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.ssh_key_pair.private_key_pem
}