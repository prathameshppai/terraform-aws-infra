terraform {
  backend "s3" {
    bucket = "terraform-storage-11042022"
    key    = "Autoscaling.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "Networking" {
  backend = "s3"
  config = {
    bucket = "terraform-storage-11042022"
    key    = "env://${terraform.workspace}/Networking.tfstate"
    region = "us-west-2"
  }
}
