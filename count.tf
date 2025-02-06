variable "instance_count" {
  type    = number
  default = 3
}

resource "aws_instance" "ec2" {
  count         = var.instance_count
  ami           = "ami-036ca7d3e7fe7595b"
  instance_type = "t3.micro"
  key_name      = "gopi_key"
}

output "instance_ids" {
  value = aws_instance.ec2[*].id
}

output "public_ips" {
  value = aws_instance.ec2[*].public_ip
}

output "private_ips" {
  value = aws_instance.ec2[*].private_ip
}
