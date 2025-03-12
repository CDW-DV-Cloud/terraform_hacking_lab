/* 
  Define the AWS Instance
*/
data "template_file" "install_script" {
  /* File template for the install script */
  template = file("install_lab.sh")
}
 resource "tls_private_key" "instance-key" {
   algorithm = "ED25519"
 }

 resource "aws_key_pair" "hl-key" {
  key_name   = "hacking-lab-key"
  public_key = tls_private_key.instance-key.public_key_openssh
}
resource "local_sensitive_file" "key-file" {
  content  = tls_private_key.instance-key.private_key_openssh
  filename = "${path.module}/sshkey-${aws_key_pair.hl-key.key_name}"
}
resource "aws_instance" "hacking-lab-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.allow_connections_hacking_lab.id}"]
  subnet_id = var.subnet_id
  /* Specify SSH Key Name for login */
  key_name = aws_key_pair.hl-key.key_name
  /* Include Bash file and execute */
  user_data = data.template_file.install_script.rendered
  tags = {
    Name = "hacking-lab-server"
  }



  /* This local exec is just for convenience and opens the ssh sessio. */
  provisioner "local-exec" {
    command = "echo putty -ssh ubuntu@${aws_instance.hacking-lab-server.public_ip} 22 -i '${var.ssh_key_path}'"
  }
}

 resource "tls_private_key" "this" {
   algorithm = "ED25519"
 }