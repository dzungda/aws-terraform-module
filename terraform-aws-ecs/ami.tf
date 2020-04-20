### container optimized cluster
data "aws_ami" "ecs_ami" {
  count       = local.is_fargate ? 0 : 1
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

