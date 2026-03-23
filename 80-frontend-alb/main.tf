resource "aws_lb" "frontend_alb" {
    name = "${var.project}-${var.environment}-frontend"
    internal = false
    load_balancer_type = "application"
    security_groups = [local.frontend_alb_sg_id]
    subnets            = local.public_subnet_ids
    enable_deletion_protection = false
    tags = merge (
        {
            Name = "${var.project}-${var.environment}-frontend"
        },
        local.common_tags
    )
}
#lets create load balancer listener
resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.frontend_alb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBsecurityPolicy-2016-08"
    certificate_arn = local.frontend_alb_certificate_arn
    default_action {
        type = "fixed_response"
        fixed_response {
            content_type = "text/html"
            message_body = "<h1>Hi, Iam from HTTPS frontend ALB </h1>"
            status_code = "200"
        }
    }
}
#lets create a route53 record using alias not with ip address
resource "aws_route53_record" "www" {
    zone_id = var.zone_id
    name = "*.${var.domain_name}"
    type = "A"
#load balancer details 
alias {
    name = aws_lb_frontend_alb.dns_name
    zone_id = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
}
allow_overwrite = true
}