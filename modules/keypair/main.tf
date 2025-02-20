resource "aws_key_pair" "this" {
  key_name   = var.key_name         # Nome da Key Pair
  public_key = var.public_key       # Conteúdo direto da chave pública
}

