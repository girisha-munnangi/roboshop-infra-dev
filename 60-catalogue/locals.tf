locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    ami_id = data.aws_ami.joindevops.id
    private_subnet_id = split (",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
    listener_arn = local.backend_alb_listener_arn
    common_tags = {
        project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}