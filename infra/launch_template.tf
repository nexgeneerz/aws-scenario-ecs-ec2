########################################################################################################################
## Get most recent AMI for an ECS-optimized Amazon Linux 2 instance
########################################################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

########################################################################################################################
## Launch template for all EC2 instances that are part of the ECS cluster
########################################################################################################################

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${var.namespace}_EC2_LaunchTemplate_${var.environment}"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_role_profile.arn
  }

  monitoring {
    enabled = true
  }

  tags = {
    Scenario = var.scenario
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    ecs_cluster_name = aws_ecs_cluster.default.name
  }
}
