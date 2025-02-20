resource "aws_route53_zone" "private_zone" {
  name = var.zone_name
  vpc {
    vpc_id = var.vpc_id
  }

  # Definindo a zona como privada
  comment = "Private hosted zone for ${var.zone_name}"
}

# Exemplo de um registro A para a zona
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "www.${var.zone_name}"
  type    = "A"
  ttl     = 60
  records = ["10.0.0.1"]
}
