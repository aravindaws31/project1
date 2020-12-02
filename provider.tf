provider "aws" {
  region     = var.aws_region
  access_key = secrets.aws_access_key
  secret_key = secrets.aws_secret_key
}
