locals {
    common_tags = {
        Project = var.Project
        Environment = var.environment
        Terraform = "true"
    }
}