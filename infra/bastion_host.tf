########################################################################################################################
## Bastion host SG and EC2 Instance
########################################################################################################################

resource "aws_security_group" "bastion_host" {
  name        = "${var.namespace}_SecurityGroup_BastionHost_${var.environment}"
  description = "Bastion host Security Group"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Scenario = var.scenario
  }
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.default.id
  vpc_security_group_ids      = [aws_security_group.bastion_host.id]

  tags = {
    Name     = "${var.namespace}_EC2_BastionHost_${var.environment}"
    Scenario = var.scenario
  }
}
