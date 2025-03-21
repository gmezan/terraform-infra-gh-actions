provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-from-gh"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}