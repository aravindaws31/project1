terraform {
  backend "s3" {
    bucket     = "tfstate0301"
    key        = "dev/test.tfstate"
    region     = "ap-south-1"
    access_key = secrets.aws_access_key
    secret_key = secrets.aws_secret_key
  }
}
