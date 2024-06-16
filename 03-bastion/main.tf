module "bation" {

    # Using open source modules.
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${var.project_name}-${var.environment}-bastion"

    instance_type = "t2-micro"
    vpc_security_group_ids = ["${data.aws_ssm_parameter.bastion_sg_id.value}"]
    #Convert stringlist to list and get the first element.
    subnet_id = local.public_subnet_id
    ami = data.aws_ami.ami_info.id
    user_data = file("bastion.sh")
    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-bastion"
        }
    )  
}