module "aws_vpc" {
  source                        = "modules/terraform-aws-vpc"
  name                          = "test"
  azs                           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
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
      "description" = "HTTP Access to Vault"
    },
    {
      "type"        = "ingress"
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "description" = "HTTPS Access to Tower"
    },
  ]
}

module "aws_alb" {
  source          = "modules/terraform-aws-elbv2"
  name            = "rhforum-alb"
  security_groups = ["${module.aws_sg_alb.sg_id}"]
  subnets         = ["${concat(module.aws_vpc.public_subnets, module.aws_vpc.private_subnets)}"]
}

module "aws_key_pair" {
  source     = "modules/terraform-aws-keypair"
  key_name   = "rhforum-2019-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4oo5BbgZwTRrm9H0gVBveYV6Rx/7ORskgz0MGcAfTRFlYfkpnZFDEox9B1xBavWUCpIKwTLgHwzcepiQ9+8hK280pMpCqnp5Q3e2EGJ3tHji6vPhZFNFjhq2b8nhY1aQFxt31L3pX2kZwjPa5cfRkeyUCwxqbbyar5sks8JxBA2l+KhelM1fR8jcXHF9MUWHfxL8bjw9AmD24p3j35UmU3yQZGShITvFdEgnLOaOXjwqylrTK0XzV4R0AO7sJrse97xZaD3jYUEFCxqf1xo2rRSD2y2goQ8WnVv66Ep9CVg/jMG99UCWNCfKZSCsopM4xBP5h5YOSC6QyBDBjXfT/ nicolas@MacBook-Pro-de-Nicolas.local"
}

module "aws_instance_bastion" {
  source = "modules/terraform-aws-instance"
  ami    = "${data.aws_ami.ami.id}"

  instance_tags = {
    "Name" = "bastion"
  }

  vm_count               = "1"
  vpc_security_group_ids = ["${module.aws_sg_bastion.sg_id}"]
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  key_name               = "${module.aws_key_pair.key_name}"
}

module "aws_record_bastion" {
  source        = "modules/terraform-aws-route53-records"
  zone_id       = "${module.aws_route53.dns_zone_id[0]}"
  instance_name = ["bastion"]
  instance_ip   = ["${module.aws_instance_bastion.instance_public_ip}"]
}

module "aws_sg_vault" {
  source      = "modules/terraform-aws-securitygroup"
  name        = "rhforum_sg_vault"
  description = "Used by Vault Server"
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
      "from_port"   = "8200"
      "to_port"     = "8200"
      "protocol"    = "tcp"
      "description" = "HTTP Access to Vault"
    },
    {
      "type"        = "ingress"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "description" = "SSH Access to Vault"
    },
  ]
}

module "aws_instance_vault" {
  source = "modules/terraform-aws-instance"
  ami    = "${data.aws_ami.ami.id}"

  instance_tags = {
    "Name" = "vault"
  }

  vm_count                    = "1"
  vpc_security_group_ids      = ["${module.aws_sg_vault.sg_id}"]
  subnet_id                   = "${module.aws_vpc.private_subnets[0]}"
  key_name                    = "${module.aws_key_pair.key_name}"
  user_data                   = "${file("files/vault_single_server-ssh-ca.sh")}"
  associate_public_ip_address = false
}

module "aws_target_group_vault" {
  source            = "modules/terraform-aws-elbv2-targetgroup"
  target_group_name = "lb-target-group-vault"

  target_group_port = "8200"

  target_group_protocol = "HTTP"
  vpc_id                = "${module.aws_vpc.vpc_id}"
  target_type           = "instance"
  instance_id           = ["${module.aws_instance_vault.instance_id}"]
}

module "aws_listener_vault" {
  source            = "modules/terraform-aws-elbv2-listener"
  load_balancer_arn = "${module.aws_alb.lb_alb_arn[0]}"
  listener_port     = "80"
  listener_protocol = "HTTP"
  target_group_arn  = "${module.aws_target_group_vault.target_group_arn[0]}"
  action_type       = "forward"
}

module "aws_sg_tower" {
  source      = "modules/terraform-aws-securitygroup"
  name        = "rhforum_sg_tower"
  description = "Used by Tower Server"
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
      "description" = "HTTP Access to Tower"
    },
    {
      "type"        = "ingress"
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "description" = "HTTPS Access to Tower"
    },
    {
      "type"        = "ingress"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "description" = "SSH Access to Vault"
    },
  ]
}

module "aws_instance_tower" {
  source = "modules/terraform-aws-instance"
  ami    = "${data.aws_ami.ami.id}"

  instance_tags = {
    "Name" = "tower"
  }

  vm_count                    = "1"
  vpc_security_group_ids      = ["${module.aws_sg_tower.sg_id}"]
  subnet_id                   = "${module.aws_vpc.private_subnets[0]}"
  key_name                    = "${module.aws_key_pair.key_name}"
  associate_public_ip_address = false
}

module "aws_acm_certificate_tower" {
  source                = "modules/terraform-aws-acm-certificate"
  acm_domain_name       = "*.demoaws.my-v-world.com"
  acm_validation_method = "DNS"
}

module "aws_record_certs_tower" {
  source        = "modules/terraform-aws-route53-records"
  zone_id       = "${module.aws_route53.dns_zone_id[0]}"
  instance_name = ["${module.aws_acm_certificate_tower.aws_acm_resource_record_name}"]
  instance_ip   = ["${module.aws_acm_certificate_tower.aws_acm_resource_record_value}"]
  record_type   = "${module.aws_acm_certificate_tower.aws_acm_resource_record_type}"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${module.aws_acm_certificate_tower.aws_acm_cert_arn}"
  validation_record_fqdns = ["${module.aws_record_certs_tower.record_fqdn}"]
}

module "aws_target_group_tower" {
  source            = "modules/terraform-aws-elbv2-targetgroup"
  target_group_name = "lb-target-group-tower"

  target_group_port = "443"

  target_group_protocol = "HTTPS"
  vpc_id                = "${module.aws_vpc.vpc_id}"
  target_type           = "instance"
  instance_id           = ["${module.aws_instance_tower.instance_id}"]
}

module "aws_listener_tower" {
  source                   = "modules/terraform-aws-elbv2-listener"
  load_balancer_arn        = "${module.aws_alb.lb_alb_arn[0]}"
  listener_port            = "443"
  listener_protocol        = "HTTPS"
  listener_ssl_policy      = "ELBSecurityPolicy-2016-08"
  listener_certificate_arn = "${module.aws_acm_certificate_tower.aws_acm_cert_arn}"
  target_group_arn         = "${module.aws_target_group_tower.target_group_arn[0]}"
  action_type              = "forward"
}

module "aws_tower_deployment" {
  source = "modules/terraform-ansible-tower"

  aws_tower_hosts       = "${module.aws_instance_tower.instance_private_dns}"
  aws_bastion_host      = "${module.aws_instance_bastion.instance_public_ip}"
  global_admin_username = "ec2-user"
  id_rsa_path           = "/users/nicolas/.ssh/id_rsa_az"
}
