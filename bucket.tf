
provider "aws" {
  region = "ap-south-2"
}
resource "aws_s3_bucket" "s3"{
  bucket = "adigopi499"
}
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3.bucket
  versioning_configuration {
     status = "Enabled"
  }
}

output "s3_bucket_name"{
  value = aws_s3_bucket.s3.bucket
}
