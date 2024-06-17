resource "aws_ssm_parameter" "acm_certficate_arn" {
  name = "/${var.project_name}/${var.environment}/acm_certficate_arn"
  type = "String"
  value = aws_acm_certificate.expense.arn
}