resource "aws_key_pair" "vpn" {
  key_name = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")       # If this is not worked. ~ means widows home directory.
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpg+hjEwIjB+J6Q8AziLf7lJLdkyBZi7oqq0URaiflIQc248F19EZyqJhLIykxymk/slxnrknPbp59707iTYKwSH3WYU1Sdyweg/ZJsWATAl37TMkQEGCxuy0eTDvF2jK9erZZzziKnMWcVQMaRr++QyW3u+oMD2hnTWs9m48l/NT+BULFd0ig1Sv4xd8EZNPSC8UW49vn1RVxlp5D1s05WuVsZAWkzIytFOnvxuX7/LKH6lhE7IZn2YJLsxy0bZd0/ChgMNgmiD3OHBhky+CXmpHA12De9ni8FImMoG6oDfpXDKhCKLDiR3uYM5c0kK9CF+CXuczso2uNwi44Rz/vOdFlp5wy+hxbOVl/D/ovicPsi/JHHyHPlmj1tviK9y799DFu40cwkO/8qnggTlPP/39zGZZQbxtqD1jlhO4fehUwQlXMthG+U1Z4VcDsBXOM0kgzhhm2ZVwjdry9YfIaS/LgmwxEaZIz+StZEuePxdQUPFgbl97Y/G5xza3dtEc= rskri@DESKTOP-5CB53I9"
}
module "vpn" {
    # Using open source modules.
    source = "terraform-aws-modules/ec2-instance/aws"
    key_name = aws_key_pair.vpn.key_name
    name = "${var.project_name}-${var.environment}-vpn"

    instance_type = "t2.micro"
    vpc_security_group_ids = ["${data.aws_ssm_parameter.vpn_sg_id.value}"]
    #Convert stringlist to list and get the first element.
    subnet_id = local.public_subnet_id
    ami = data.aws_ami.ami_info.id
    
    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-vpn"
        }
    )  
}