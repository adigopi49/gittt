resource "aws_instance" "ec2" {
  ami             = "ami-09e6cc9a368c9cf4b"
  instance_type   = "t3.micro"
  security_groups = ["default"]
  key_name        = "gopi_key"

  provisioner "local-exec" {
    command = "echo Provisioning complete for ${self.public_ip}"
  }
}
