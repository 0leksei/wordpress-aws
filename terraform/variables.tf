##################
# Define variables
##################

####################
# AWS Account details
####################
variable "aws_access_key" {
  description = "AWS access key"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default     = ""
}

variable "aws_region" {
  description = "AWS region name"
  default     = ""
}

variable "azs" {
  description = "Availability zones in AWS region"
  type        = "list"
  default     = []
}

variable "environment" {
  description = "Environment name"
  default     = ""
}

variable "common_tags" {
  type        = "map"
  description = "Other common tags"
  default = {}
}

####################
## VPC details
####################
variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = ""
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = "list"
  default     = []
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = "list"
  default     = []
}

####################
## Security group details
####################
variable "cidr_blocks_allowed_ssh" {
  description = "CIDR blocks allowed to access Bastion over SSH"
  type        = "map"
  default     = {}
}

variable "cidr_blocks_allowed_http" {
  description = "CIDR blocks allowed to HTTP into Web instance"
  type        = "map"
  default     = {}
}

####################
## EC2 details
####################
variable "instance_type_bastion" {
  description = "EC2 instance type"
  default     = ""
}

variable "instance_type_web" {
  description = "Web EC2 instance type"
  default     = ""
}

variable "instance_type_db" {
  description = "Database EC2 instance type"
  default     = ""
}

variable "ssh_public_key_name" {
  type        = "string"
  description = "SSM Parameter name of the SSH public key"
  default     = "aleksei-ec2-key.pub"
}

variable "ssh_private_key_name" {
  type        = "string"
  description = "SSM Parameter name of the SSH private key"
  default     = "aleksei-ec2-key"
}

variable "ssh_key_algorithm" {
  type        = "string"
  description = "SSH key algorithm to use. Currently-supported values are 'RSA' and 'ECDSA'"
  default     = "RSA"
}

variable "ssm_path_prefix" {
  type        = "string"
  description = "The SSM parameter path prefix"
  default     = "ssh_keys"
}