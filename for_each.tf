variable "environment_configs" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
  default = {
    "dev" = {
      ami           = "ami-036ca7d3e7fe7595b" # Amazon Linux
      instance_type = "t3.micro"
    },
    "prod" = {
      ami           = "ami-0e386fa0b67b8b12c" # Ubuntu
      instance_type = "t3.micro"
    },
    "test" = {
      ami           = "ami-062ac8503700dc4d0"  # Redhat
      instance_type = "t3.micro"
    }
  }
}

resource "aws_instance" "ec2" {
  for_each      = var.environment_configs
  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = "gopi_key"
}
