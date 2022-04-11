terraform {
  backend "s3" {
    bucket = "terraform-storage-11042022"
    key    = "Networking/terraform.tfstate"
    region = var.region
  }
}

module "vpc" {
  source    = "../modules"
}

