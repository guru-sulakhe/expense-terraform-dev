module "db"{
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for DB MYSQL instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value # storing vpc_id in aws_ssm_parameter
    common_tags = var.common_tags
    sg_name = "db"
}
# here security groups are created based on vpc_id which will be stored in the aws_ssm_parameter 
module "backend"{
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for backend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}
module "frontend"{
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for frotend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}

module "bastion"{
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for bastion instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}
module "ansible"{
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for ansible instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "ansible"
}
#DB is accepting connections from backend
# allowing only 3306 port traffic of db from the instances which are created on sg(expense-dev-backend)
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id # source refers to where you getting traffic from i..e sg(expense-dev-backend)
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source refers to where you getting traffic from i..e sg(expense-dev-bastion)
  security_group_id = module.db.sg_id
}

#backend is accepting connections from frontend
# allowing only 8080 port traffic of backend from the instances which are created on sg(expense-dev-frontend)
resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source refers to where you getting traffic from i..e sg(expense-dev-frontend)
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source refers to where you getting traffic from i..e sg(expense-dev-frontend)
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id # source refers to where you getting traffic from i..e sg(expense-dev-frontend)
  security_group_id = module.backend.sg_id
}
# frontend is accepting connections from public
# allowing only 80 port traffic of frontend from public
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source refers to where you getting traffic from public
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source refers to where you getting traffic from public
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id # source refers to where you getting traffic from public
  security_group_id = module.frontend.sg_id
}

# bastion to public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source refers to where you getting traffic from public
  security_group_id = module.bastion.sg_id
}

# ansible to public
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source refers to where you getting traffic from public
  security_group_id = module.ansible.sg_id
}


