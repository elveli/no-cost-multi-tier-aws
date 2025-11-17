locals {
  public_subnet_info = [
    for idx, az in var.availability_zones : {
      name = "no-cost-public-subnet-${idx + 1}"
      cidr = var.public_subnets[idx]
      az   = az
    }
  ]

  private_subnet_info = [
    for idx, az in var.availability_zones : {
      name = "no-cost-private-subnet-${idx + 1}"
      cidr = var.private_subnets[idx]
      az   = az
    }
  ]
}

