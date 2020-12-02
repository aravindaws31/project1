variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_vpc_cidr" {
  default = ["10.0.0.0/16"]
}

variable "aws_pubsub_cidr" {
  default = ["10.0.1.0/24"]
}

variable "aws_pvtsub_cidr" {
  default = ["10.0.2.0/24"]
}
