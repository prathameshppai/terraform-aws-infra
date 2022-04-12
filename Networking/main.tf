terraform {
  backend "s3" {
    bucket = "terraform-storage-11042022"
    key    = "Networking.tfstate"
    region = "us-west-2"
  }
}

module "vpc" {
  source    = "../modules"
}

