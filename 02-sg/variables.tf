variable "project_name" {
    default = "expense"
}
variable "environment" {
    default = "dev"
}
variable "common_tags" {
    type = map
    default = {
        Project = "expense"
        Enviroment = "dev"
        Terraform = true
    }
}