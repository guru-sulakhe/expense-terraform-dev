# storing db.sg_id in aws_ssm_parameter
resource "aws_ssm_parameter" "db_sg_id" {
  name  = "/${var.project_name}/${var.environment}/db_sg_id"
  type  = "String"
  value = module.db.sg_id 
}

# storing backend.sg_id in aws_ssm_parameter
resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/backend_sg_id"
  type  = "String"
  value = module.backend.sg_id 
}

# storing frontend.sg_id in aws_ssm_parameter
resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id 
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project_name}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id 
}

resource "aws_ssm_parameter" "ansible_sg_id" {
  name  = "/${var.project_name}/${var.environment}/ansible_sg_id"
  type  = "String"
  value = module.ansible.sg_id 
}

# here aws_ssm_parameter will acts as the storage for the vpc_id of module vpc which can be useful for the extracting the data of vpc,sg,database
# thus it is essential to include vpc_id in the ssm parameter for the creation of parameter in aws.