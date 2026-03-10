data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
    #to make sure you get this vpc_id we have to run terraform apply for 00-vpc folder also, so that 
    # 00-vpc will push the vpc_id to ssm parameter store ,then in 10-sg we can get the vpc_id from ssm parameter store
}