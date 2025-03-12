locals {
  allowed_ips = concat(
    ["${chomp(data.http.external_ip.body)}/32"],
    [for ip in var.ip_whitelist : "${ip}/32"]
  )
}

resource "aws_security_group" "allow_connections_hacking_lab" {
  name        = "allow_connections_hacking_lab"
  description = "Allow TLS inbound traffic for ssh but only for host PCs external IP. Created with terraform for the hacking lab"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
  /* Hackazon */
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
  /* DVWA */
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
  /* Juice Shop */
  ingress {
    from_port   = 82
    to_port     = 82
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
  /* Shellshock */
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }

  tags = {
    Name = "allow_connections_hacking_lab"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
}