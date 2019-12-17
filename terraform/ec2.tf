####################
# EC2 setup
####################

# Find Ubuntu AMI
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

# Create TLS SSH key pair and store in SSM. Create EC2 key pair from it
module "ssm_tls_ssh_key_pair" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-ssh-key-pair.git?ref=master"
  name                 = "aleksei-key"
  ssm_path_prefix      = "${var.ssm_path_prefix}"
  ssh_key_algorithm    = "${var.ssh_key_algorithm}"
  ssh_private_key_name = "${var.ssh_private_key_name}"
  ssh_public_key_name  = "${var.ssh_public_key_name}"
  kms_key_id           = "alias/aws/ssm"
}

# Create EC2 key pair from TLS SSH key created above
resource "aws_key_pair" "key_pair" {
  key_name    = "aleksei-ec2-key"
  public_key  = "${module.ssm_tls_ssh_key_pair.public_key}"
}

####################
# Create Bastion host
####################

# Create Elastic IP for bastion host
resource "aws_eip" "bastion" {
  vpc           = true
  depends_on    = ["aws_instance.bastion"]
  instance      = "${aws_instance.bastion.id}"
  tags          = "${merge(map("Environment", var.environment), var.common_tags)}"
}

# Bastion host
resource "aws_instance" "bastion" {
  ami                           = "${data.aws_ami.ubuntu.id}"
  instance_type                 = "${var.instance_type_bastion}"
  key_name                      = "${aws_key_pair.key_pair.key_name}"
  subnet_id                     = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids        = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address   = true
  user_data                     = "${file("../userdata/bastion.sh")}"
  root_block_device {
        volume_type = "gp2"
        volume_size = 10
  }
  tags = "${merge(map("Environment", var.environment), var.common_tags, map("Role", "Bastion"))}"
  volume_tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}

####################
# Create Web instance
####################

# Create Elastic IP for web instance
resource "aws_eip" "web" {
  vpc           = true
  depends_on    = ["aws_instance.web"]
  instance      = "${aws_instance.web.id}"
  tags          = "${merge(map("Environment", var.environment), var.common_tags)}"
}

# Web host
resource "aws_instance" "web" {
  ami                           = "${data.aws_ami.ubuntu.id}"
  instance_type                 = "${var.instance_type_web}"
  key_name                      = "${aws_key_pair.key_pair.key_name}"
  subnet_id                     = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids        = ["${aws_security_group.web.id}"]
  associate_public_ip_address   = true
  user_data                     = "${file("../userdata/web.sh")}"
  root_block_device {
        volume_type = "gp2"
        volume_size = 50
  }
  tags = "${merge(map("Environment", var.environment), var.common_tags, map("Role", "Web"))}"
  volume_tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}

####################
# Create Database instance
####################

# DB host
resource "aws_instance" "db" {
  ami                           = "${data.aws_ami.ubuntu.id}"
  instance_type                 = "${var.instance_type_db}"
  key_name                      = "${aws_key_pair.key_pair.key_name}"
  subnet_id                     = "${element(module.vpc.private_subnets, 0)}"
  vpc_security_group_ids        = ["${aws_security_group.db.id}"]
  associate_public_ip_address   = false
  user_data                     = "${file("../userdata/db.sh")}"
  root_block_device {
        volume_type = "gp2"
        volume_size = 50
  }
  tags = "${merge(map("Environment", var.environment), var.common_tags, map("Role", "Database"))}"
  volume_tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}