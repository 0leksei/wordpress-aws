# AWS details
environment         = "test"
aws_region          = "eu-west-1"

# VPC details
vpc_cidr            = "10.63.0.0/16"
public_subnets      = ["10.63.1.0/24", "10.63.2.0/24", "10.63.3.0/24"]
private_subnets     = ["10.63.11.0/24", "10.63.12.0/24", "10.63.13.0/24"]
azs                 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# Optional tags to apply on all resources
common_tags = {
    "Owner"        = "Aleksei Hodunkov"
    "Duedate"      = "2019-12-31"
}

# EC2 details
instance_type_bastion   = "t3.small"
instance_type_web       = "t3.small"
instance_type_db        = "t3.small"

# CIDR blocks allowed to SSH into Bastion host
cidr_blocks_allowed_ssh = {
    "91.129.108.117/32" = "Aleksei IP 1"
    "213.219.110.42/32" = "Aleksei IP 2"
}

# CIDR blocks allowed to HTTP into Web server
cidr_blocks_allowed_http = {
    "91.129.108.117/32" = "Aleksei IP 1"
    "213.219.110.42/32" = "Aleksei IP 2"
}
