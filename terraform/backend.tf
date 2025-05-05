terraform {
  backend "s3" {
    bucket         = "ghjkl-bucket"
    key            = "key/terraform.tfstate"
    region         = "us-east-1"
  }
}
