resource "aws_security_group" "rds_security_group" {
  vpc_id = "${aws_vpc.example_vpc.id}"
  name         = "rds security group"

  # local vpn access postgresql
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.public_subnet.cidr_block}", "${aws_subnet.private_subnet_a.cidr_block}",  "${aws_subnet.private_subnet_b.cidr_block}"]
  }

  # local machine running terraform access postgresql
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

resource "aws_security_group" "lambda_security_group" {
  vpc_id = "${aws_vpc.example_vpc.id}"
  name = "lambda security group"

  egress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.public_subnet.cidr_block}", "${aws_subnet.private_subnet_a.cidr_block}", "${aws_subnet.private_subnet_b.cidr_block}"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
