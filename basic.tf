
terraform {
  backend "s3" {
    bucket = "terraform-backend"
    key    = "workspaces/gittt/day1/terraform.tfstate"  # Corrected path without the leading '/'
    region = "ap-south-2"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-036ca7d3e7fe7595b"  # Replace with your desired AMI ID
  instance_type = "t3.micro"
  key_name      = "gopi_key"
  security_groups = ["default"]

  tags = {
    Name = "ExampleEC2Instance"
  }
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value = aws_instance.ec2.public_ip
}

# Output the private IP of the EC2 instance
output "private_ip" {
  value = aws_instance.ec2.private_ip
}
