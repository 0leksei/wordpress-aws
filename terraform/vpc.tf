##################
# Create AWS VPC
##################
module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "2.17.0"
  name                  = "aleksei-vpc"
  cidr                  = "${var.vpc_cidr}"
  azs                   = "${var.azs}"
  private_subnets       = "${var.private_subnets}"
  public_subnets        = "${var.public_subnets}"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  enable_nat_gateway    = true
  single_nat_gateway    = true

  public_subnet_tags      = {
    Tier                                        = "public"
  }

  private_subnet_tags = {
    Tier                                        = "private"
  }

  tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}