########################################################################################################################
## Create Route53 Hosted Zone for the domain of the service including NS records in the top level domain.
## For this scenario, we assume that the service is running on a subdomain, like service.example.com.
########################################################################################################################

resource "aws_route53_zone" "service" {
  name  = var.domain_name
}

resource "aws_route53_record" "service" {
  zone_id = var.tld_zone_id
  name    = var.domain_name
  type    = "NS"
  ttl     = 300
  records = [
    aws_route53_zone.service.name_servers[0],
    aws_route53_zone.service.name_servers[1],
    aws_route53_zone.service.name_servers[2],
    aws_route53_zone.service.name_servers[3]
  ]
}

########################################################################################################################
## Hosted zone for development subdomain of our service
########################################################################################################################

resource "aws_route53_zone" "environment" {
  name  = "${var.environment}.${var.domain_name}"
}

resource "aws_route53_record" "environment" {
  zone_id = aws_route53_zone.service.id
  name    = "${var.environment}.${var.domain_name}"
  type    = "NS"
  ttl     = 300
  records = [
    aws_route53_zone.environment.name_servers[0],
    aws_route53_zone.environment.name_servers[1],
    aws_route53_zone.environment.name_servers[2],
    aws_route53_zone.environment.name_servers[3]
  ]
}

########################################################################################################################
## Point A record to CloudFront distribution
########################################################################################################################

resource "aws_route53_record" "service_record" {
  name    = "${var.environment}.${var.domain_name}"
  type    = "A"
  zone_id = aws_route53_zone.environment.id

  alias {
    name                   = aws_cloudfront_distribution.default.domain_name
    zone_id                = aws_cloudfront_distribution.default.hosted_zone_id
    evaluate_target_health = false
  }
}
