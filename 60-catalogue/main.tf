resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    subnet_id = local.private_subnet_id
    vpc_security_group_ids = [local.catalogue_sg_id]
    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
}
resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]
    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.catalogue.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh catalogue"
        ]
    }

}
resource "aws_ec2_instance_state" "catalogue" {
    instance_id = aws_instance.catalogue.id
    state = "stopped"
    depends_on = [terraform_data.catalogue]
}
resource "aws_ami_from_instance" "catalogue" {
    name = "${var.project}-${var.environment}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    source_instance_id = aws_instance.catalogue.id
    depends_on = [aws_ec2_instance_state.catalogue]
    tags=merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
}
#create target group
resource "aws_lb_target_group" "catalogue" {
    name = "${var.project}-${var.environment}-catalogue"
    port = 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id
    deregistration_delay = 60
    health_check{
        healthy_threshold = 2
        interval = 10
        matcher = "200-299"
        path = "/health"
        port = 8080
        protocol = "HTTP"
        timeout = 2
        unhealthy_threshold = 3
    }
}
#create launch template which requires all fields to create an ec2 instance & image id 
resource "aws_launch_template" "catalogue" {
    name = "${var.project}-${var.environment}-catalogue"
    image_id = aws_ami_from_instance.catalogue.id
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue.sg_id]
    update_default_version = true
    tags_specifications {
        resource_type = "instance"
        tags= merge(
            {#ec2 instance name 
                Name = "${var.project}-${var.environment}-catalogue"
            },
            local.common_tags
        )
    }
    tags_specifications {
        resource_type = "volume"
        tags= merge (
            {#ebs volume name 
                Name = "${var.project}-${var.environment}-catalogue"
            },
            local.common_tags
        )
    }
    tags = merge (
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
} 