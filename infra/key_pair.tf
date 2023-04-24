########################################################################################################################
## Create a public and private key pair for login to the EC2 Instances
########################################################################################################################

resource "aws_key_pair" "default" {
  key_name   = "${var.namespace}_KeyPair_${var.environment}"
  public_key = var.public_ec2_key

  tags = {
    Scenario = var.scenario
  }
}
