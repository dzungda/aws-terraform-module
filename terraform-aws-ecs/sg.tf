# sg.tf/ look up default security group

data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default*"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }
}

