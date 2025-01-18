data "aws_ssm_parameter" "vpc_id" { #this will query vpc_id from the module vpc
  name = "/${var.project_name}/${var.environment}/vpc_id"
}
#Note: display the resource ID in the module development process in the outputs.tf, Later in the module usage it will the parameter