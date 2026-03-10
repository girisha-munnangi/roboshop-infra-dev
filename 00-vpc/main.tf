module "vpc" {
    source = "../../tf-common-aws-vpc"
    project = var.project
    environment = var.environment
    is_peering_required = true
}