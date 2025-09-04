resource "aws_route53_zone" "jideweb_zone" {
  name = "ruby.click"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.jideweb_zone.id
  name    = "www.ruby.click"
  type    = "A"

  #records = [var.internal_load_balancer_public_ip]
  alias {
    name                   = var.external_load_balancer_public_ip
    zone_id                = var.external_load_balancer_zone_id
    evaluate_target_health = true
  }
}
