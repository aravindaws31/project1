terraform {
  backend "s3" {
    bucket     = "tfstatebucket0112"
    key        = "dev/test.tfstate"
    region     = "eu-west-2"
    access_key = secrets.aws_access_key
    secret_key = secrets.aws_secret_key
  }
}
