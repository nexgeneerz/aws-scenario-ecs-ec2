########################################################################################################################
# AWS provider setup
########################################################################################################################

provider "aws" {
  alias      = "main"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.region
}

provider "aws" {
  alias      = "us_east_1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = "us-east-1"
}
