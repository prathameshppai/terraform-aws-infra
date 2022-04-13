output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value = module.vpc.private_subnets
}

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}
