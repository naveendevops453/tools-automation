resource "aws_security_group" "main" {
  name        = var.name
  description = var.name

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = var.port_no
    to_port          = var.port_no
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile = aws_iam_instance_profile.main.name

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                       = 0.0886
      instance_interruption_behavior  = "stop"
      spot_instance_type              = "persistent"
    }
  }
  tags = {
    Name = var.name
  }

}
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.name}.devopsengineer2.online"
  type    = "A"
  ttl     = 5
  records = [aws_instance.main.public_ip]
}

resource "aws_route53_record" "private" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.name}-internal.devopsengineer2.online"
  type    = "A"
  ttl     = 5
  records = [aws_instance.main.private_ip]
}
