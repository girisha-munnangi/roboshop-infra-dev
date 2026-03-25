module "componet" {
    for_each = var.components
    source = "git::https://github.com/girisha-munnangi/terraform-roboshop-component.git?ref=main"
    component = each.key
    rule_priority = each.value.rule_priority
}