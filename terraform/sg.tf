##################
# Configure security groups
##################

####################
# Security group for Bastion
####################
resource "aws_security_group" "bastion" {
  name        = "aleksei-bastion"
  description = "Access to Bastion"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(map("Environment", var.environment), var.common_tags)}"
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "access_bastion" {
  count             = "${length(var.cidr_blocks_allowed_ssh)}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion.id}"
  cidr_blocks       = ["${element(keys(var.cidr_blocks_allowed_ssh), count.index)}"]
  description       = "${var.cidr_blocks_allowed_ssh["${element(keys(var.cidr_blocks_allowed_ssh), count.index)}"]}"
}

####################
# Security group for Web instance
####################
resource "aws_security_group" "web" {
  name        = "aleksei-web"
  description = "Access to web"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(map("Environment", var.environment), var.common_tags)}"
}

resource "aws_security_group_rule" "web_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "web_http" {
  count             = "${length(var.cidr_blocks_allowed_http)}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.web.id}"
  cidr_blocks       = ["${element(keys(var.cidr_blocks_allowed_http), count.index)}"]
  description       = "${var.cidr_blocks_allowed_http["${element(keys(var.cidr_blocks_allowed_http), count.index)}"]}"
}

resource "aws_security_group_rule" "web_https" {
  count             = "${length(var.cidr_blocks_allowed_http)}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.web.id}"
  cidr_blocks       = ["${element(keys(var.cidr_blocks_allowed_http), count.index)}"]
  description       = "${var.cidr_blocks_allowed_http["${element(keys(var.cidr_blocks_allowed_http), count.index)}"]}"
}

resource "aws_security_group_rule" "web_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${aws_security_group.web.id}"
}

####################
# Security group for Database instnace
####################
resource "aws_security_group" "db" {
  name        = "aleksei-db"
  description = "Access to database"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(map("Environment", var.environment), var.common_tags)}"
}

resource "aws_security_group_rule" "database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.db.id}"
}

resource "aws_security_group_rule" "database_bastion_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${aws_security_group.db.id}"
}

resource "aws_security_group_rule" "database_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${aws_security_group.db.id}"
}

resource "aws_security_group_rule" "database_web" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.web.id}"
  security_group_id        = "${aws_security_group.db.id}"
}