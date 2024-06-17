data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "prublic_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/prublic_subnet_ids"
}

/* data "aws_ssm_parameter" "web_alb_listener_arn_https" {
  name = "/${var.project_name}/${var.environment}/web_alb_listener_arn_https"
} */

data "aws_ssm_parameter" "acm_certficate_arn" {
  name = "/${var.project_name}/${var.environment}/acm_certficate_arn"
}