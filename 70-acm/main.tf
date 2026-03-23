#creating acm certificate
resource "aws_acm_certificate" "roboshop" {
    domain_name = "*.${domain_name}"
    validation_method = "DNS"
    tags = merge (
        {
            Name = "${var.project} - ${var.environment} - ${var.domain_name}"
        },
        local.common_tags
    ) 
    lifecycle{
        create_before_destroy = true
    }
}
#creating route53 records
resource "aws_route53_record" "roboshop" {
    for_each = {
        for dvo in aws_acm_certificate.roboshop.domain_validation_options:dvo.domain-name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = var.zone_id
}
#validating aws acm certificate validation
resource "aws_acm_certificate_validation" "roboshop" {
    certificate_arn = aws_acm_certificate.roboshop.certificate_arn
    Validation_record_fqdns = [for record in aws_route53_record.roboshop:record.fqdn]
}