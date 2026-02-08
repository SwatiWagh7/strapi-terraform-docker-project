############################################
# VPC
############################################

module "vpc" {
  source = "./modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

############################################
# Security Groups
############################################

module "security" {
  source = "./modules/security"

  vpc_id      = module.vpc.vpc_id
  strapi_port = var.strapi_port
}

############################################
# EC2 – Strapi (PRIVATE)
############################################

module "ec2_strapi" {
  source = "./modules/ec2-strapi"

  environment       = var.environment
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.private_subnets[0]
  security_group_id = module.security.ec2_sg_id


  nat_dependency = module.vpc.nat_gateway_id

}

############################################
# Application Load Balancer
############################################

module "alb" {
  source = "./modules/alb"

  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.security.alb_sg_id
  target_instance = module.ec2_strapi.instance_id
  strapi_port     = var.strapi_port

  depends_on = [
    module.ec2_strapi
  ]
}
