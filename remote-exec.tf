resource "aws_instance" "ec2" {
  ami             = "ami-09e6cc9a368c9cf4b"
  instance_type   = "t3.micro"
  security_groups = ["default"]
  key_name        = "gopi_key"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/workspaces/gittt/provisinors/key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl restart httpd",
      "wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip",
      "unzip 2135_mini_finance.zip",
      "sudo mv 2135_mini_finance/* /var/www/html",
      "echo 'Provisioning complete!'"
    ]
  }
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
