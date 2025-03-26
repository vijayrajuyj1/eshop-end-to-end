terraform {
  backend "s3" {
    bucket = "vijay-980-vi"
    region = "us-east-1"
    key = "vijay/terraform.tfstate"
  }
}