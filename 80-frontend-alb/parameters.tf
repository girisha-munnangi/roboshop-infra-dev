resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
name = "/${var.project}-/${var.environment}/frontend-alb-listener-arn"
type = String
value = aws_lb_listener.https.arn
}