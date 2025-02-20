# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name}-alb" # Define o nome diretamente
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-alb" # Adiciona o nome como uma tag
    }
  )
}

# Target Group para as Instâncias EC2
resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg" # Nome do Target Group
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tg" # Nome como tag
    }
  )
}

# Security Group do ALB (opcional)
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg" # Nome do Security Group
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-alb-sg" # Nome como tag
    }
  )
}

# Listener para o ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn # ARN do ALB
  port              = 80              # Porta do listener (HTTP)
  protocol          = "HTTP"          # Protocolo do listener
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn # Target Group associado
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn # Target Group ARN
  target_id        = var.instance_ids[0]         # ID da instância EC2 (primeira da lista)
  port             = 80                          # Porta de destino
}