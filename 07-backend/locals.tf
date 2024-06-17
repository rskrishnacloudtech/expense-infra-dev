locals {
    # Convert stringlist to list and get the first element.
    private_subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_ids.value), 0)
}