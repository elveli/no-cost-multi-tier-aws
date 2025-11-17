provider "aws" {
  region = var.region
}

# -----------------------------
# NETWORK MODULE
# -----------------------------
module "vpc" {
  source          = "./modules/vpc"
  region          = var.region
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# -----------------------------
# ALB MODULE
# -----------------------------
module "alb" {
  source   = "./modules/alb"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnets
}

# -----------------------------
# ASG MODULE
# -----------------------------
module "asg" {
  source               = "./modules/asg"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  alb_target_group_arn = module.alb.target_group_arn
  alb_sg_id            = module.alb.alb_sg_id
  instance_type        = var.instance_type
  scale_up_threshold   = var.scale_up_threshold
  scale_down_threshold = var.scale_down_threshold
}

