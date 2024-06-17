module "db" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQl Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "db"  
}

module "backend" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "backend"  
}

module "frontend" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for frontend Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "frontend"  
}

module "bastion" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for bastion Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "bastion"
}

module "app_alb" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for APP ALB Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "app-alb"
}

module "vpn" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for vpn Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "vpn"
  ingress_rules = var.vpn_sg_rules
}

module "web_alb" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Web ALB Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "web-alb"
}

/* module "ansible" {
  source = "../../terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for ansible Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "ansible"
} */

resource "aws_security_group_rule" "db_backend" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.db.sg_id
}

/* resource "aws_security_group_rule" "backend_frontend" {
  type = ingress
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.frontent.sg_id
  security_group_id = module.backend.sg_id
} */

resource "aws_security_group_rule" "backend_app_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.app_alb.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

/* resource "aws_security_group_rule" "backend_ansible" {
  type = ingress
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.backend.sg_id
} */

resource "aws_security_group_rule" "frontend_public" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

/* resource "aws_security_group_rule" "frontend_ansible" {
  type = ingress
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.frontend.sg_id
} */

resource "aws_security_group_rule" "bastion_public" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

/* resource "aws_security_group_rule" "ansible_public" {
  type = ingress
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id
} */

resource "aws_security_group_rule" "app_alb_vpn" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.app_alb.sg_id
}
