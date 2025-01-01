data "aws_subnet" "target" {
  id = var.subnet
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_subnet.target.vpc_id

  tags = var.global_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = data.aws_subnet.target.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = "t2.micro"
  associate_public_ip_address = false
  subnet_id = data.aws_subnet.target.id
  security_groups = [aws_security_group.allow_tls.id]

  root_block_device {
    volume_size = 30
  }

  tags = merge(
    var.global_tags,
    {
      Name = "sample-instance",
      AMI = var.ami

    },
  )
}
