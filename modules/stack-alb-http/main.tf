/*
 =================================
 network configuration
 =================================
*/

// 1. Lookup for required network data (VPC, and subnets)
module "network_data" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/lookup-data?ref=v1.14.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  vpc_data = {
    name                     = local.vpc_name_normalised
    retrieve_subnets_private = true
    retrieve_subnets_public  = true
  }
  tags = local.tags
}

locals {
  vpc_data            = !local.is_enabled ? null : lookup(module.network_data[local.stack]["vpc_data"], local.vpc_name_normalised)
  subnet_public_data  = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_public_data"], local.vpc_name_normalised)
  subnet_private_data = !local.is_enabled ? null : lookup(module.network_data[local.stack]["subnet_private_data"], local.vpc_name_normalised)

  vpc_id         = lookup(local.vpc_data, "id")
  subnets_public = lookup(local.subnet_public_data, "ids")
}

// 2. Create a security group for the ALB
module "alb_security_group" {
  for_each   = local.stack_config_map
  source     = "git::github.com/Excoriate/terraform-registry-aws-networking//modules/security-group?ref=v1.14.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  security_group_config = [
    {
      name        = format("%s-alb-sg", local.stack_full)
      description = format("Firewall test 1 for %s stack", local.stack_full)
      vpc_id      = local.vpc_id
    }
  ]

  depends_on = [
    module.network_data
  ]

  tags = local.tags
}

// 3. Create the ALB. If it's set as internet facing, lookup for the public subnets
