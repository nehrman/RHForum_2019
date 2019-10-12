module "aws_vpc" {
  source                        = "modules/terraform-aws-vpc"
  name                          = "test"
  internet_gateway              = "true"
  single_nat_gateway            = "true"
  vpc_cidr_block                = "10.0.0.0/16"
  vpc_public_subnet_cidr_block  = ["10.0.1.0/24"]
  vpc_private_subnet_cidr_block = ["10.0.10.0/24", "10.0.11.0/24"]
}

module "aws_route53" {
  source                        = "modules/terraform-aws-route53"
  public_zone_name              = ["demoaws.my-v-world.com"]
  comment                       = "Used for HashiCorp Demos"
}

module "aws_sg_bastion" {
  source                        = "modules/terraform-aws-securitygroup"
  name                          = "rhforum_sg_bastion"
  description                   = "Used by Bastion Host"
  vpc_id                        = "${module.aws_vpc.vpc_id}"
}
