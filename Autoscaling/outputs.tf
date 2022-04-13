output "vpc_cidr_block" {
  value = data.terraform_remote_state.Networking.outputs.vpc_cidr_block
}

