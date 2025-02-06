provider "aws" {
  region = "ap-south-2"
}

resource "aws_instance" "ec2" {
  ami             = var.environment == "prod" ? "ami-0e386fa0b67b8b12c" : "ami-036ca7d3e7fe7595b" # 2v is ubuntu : 5b is amazon
  key_name        = "gopi_key"
  security_groups = ["default"]
  instance_type   = "t3.micro"
  
  tags = {
    Name = "gopi"
  }
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

