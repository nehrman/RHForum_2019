module "aws_vpc" {
  source                        = "modules/terraform-aws-vpc"
  name                          = "test"
  azs                           = ["eu-central-1a", "eu-central-1b"]
  internet_gateway              = "true"
  single_nat_gateway            = "true"
  vpc_cidr_block                = "10.0.0.0/16"
  vpc_public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_private_subnet_cidr_block = ["10.0.10.0/24", "10.0.11.0/24"]
}

module "aws_route53" {
  source           = "modules/terraform-aws-route53"
  public_zone_name = ["demoaws.my-v-world.com"]
  comment          = "Used for HashiCorp Demos"
}

module "aws_sg_bastion" {
  source      = "modules/terraform-aws-securitygroup"
  name        = "rhforum_sg_bastion"
  description = "Used by Bastion Host"
  vpc_id      = "${module.aws_vpc.vpc_id}"
}

module "aws_sg_alb" {
  source      = "modules/terraform-aws-securitygroup"
  name        = "rhforum_sg_alb"
  description = "Used by Load Balancer"
  vpc_id      = "${module.aws_vpc.vpc_id}"

  custom_security_rules = [{
    "type"        = "egress"
    "from_port"   = "0"
    "to_port"     = "65535"
    "protocol"    = "-1"
    "description" = "Allow all"
  },
    {
      "type"        = "ingress"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "description" = "HTTP Access to Application LB"
    },
  ]
}

module "aws_alb" {
  source          = "modules/terraform-aws-elbv2"
  name            = "rhforum-alb"
  security_groups = ["${module.aws_sg_alb.sg_id}"]
  subnets         = ["${module.aws_vpc.public_subnets}"]
}

module "aws_key_pair" {
  source     = "modules/terraform-aws-keypair"
  key_name   = "rhforum-2019-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4oo5BbgZwTRrm9H0gVBveYV6Rx/7ORskgz0MGcAfTRFlYfkpnZFDEox9B1xBavWUCpIKwTLgHwzcepiQ9+8hK280pMpCqnp5Q3e2EGJ3tHji6vPhZFNFjhq2b8nhY1aQFxt31L3pX2kZwjPa5cfRkeyUCwxqbbyar5sks8JxBA2l+KhelM1fR8jcXHF9MUWHfxL8bjw9AmD24p3j35UmU3yQZGShITvFdEgnLOaOXjwqylrTK0XzV4R0AO7sJrse97xZaD3jYUEFCxqf1xo2rRSD2y2goQ8WnVv66Ep9CVg/jMG99UCWNCfKZSCsopM4xBP5h5YOSC6QyBDBjXfT/ nicolas@MacBook-Pro-de-Nicolas.local"
}

module "aws_instance_bastion" {
  source                 = "modules/terraform-aws-instance"
  ami                    = "${data.aws_ami.ami.id}"
  vm_count               = "1"
  vpc_security_group_ids = ["${module.aws_sg_bastion.sg_id}"]
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  key_name               = "${module.aws_key_pair.key_name}"
}

module "aws_instance_vault" {
  source                 = "modules/terraform-aws-instance"
  ami                    = "${data.aws_ami.ami.id}"
  vm_count               = "1"
  vpc_security_group_ids = ["${module.aws_sg_bastion.sg_id}"]
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  key_name               = "${module.aws_key_pair.key_name}"
}
