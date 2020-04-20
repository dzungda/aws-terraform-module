# Container cluster for microservice

### register cluster id
data "template_file" "this_userdata" {
  count    = local.is_fargate ? 0 : 1
  template = file("${path.module}/res/cluster.tpl")

  vars = {
    ssh_port    = local.ssh_port
    ecs_cluster = aws_ecs_cluster.this.id
  }
}

### Launch configuration
resource "aws_launch_configuration" "this" {
  count                = local.is_fargate ? 0 : 1
  image_id             = data.aws_ami.ecs_ami[0].id
  instance_type        = local.instance_type
  key_name             = local.ssh_key
  name_prefix          = "${local.name}-ecs-cluster"
  user_data            = data.template_file.this_userdata[0].rendered
  iam_instance_profile = aws_iam_instance_profile.ec2cluster.name

  root_block_device {
    volume_type = "gp2"
    volume_size = local.node_vol_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

### Auto scaling group
resource "aws_autoscaling_group" "this" {
  count                = local.is_fargate ? 0 : 1
  name                 = "${local.name}-ecs-cluster"
  max_size             = local.node_max_size
  min_size             = local.node_min_size
  desired_capacity     = local.node_desired_size
  vpc_zone_identifier  = var.subnets
  availability_zones   = var.azs
  launch_configuration = aws_launch_configuration.this[0].name
  force_delete         = true
  termination_policies = ["Default"]

  lifecycle {
    create_before_destroy = true
  }

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "${local.name}-ecs-cluster"
        "propagate_at_launch" = "true"
      },
    ],
    var.tags,
  )
}

resource "aws_autoscaling_policy" "scale_out" {
  count                  = local.is_fargate ? 0 : 1
  name                   = "${local.name}-scaleout"
  autoscaling_group_name = aws_autoscaling_group.this[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_in" {
  count                  = local.is_fargate ? 0 : 1
  name                   = "${local.name}-scalein"
  autoscaling_group_name = aws_autoscaling_group.this[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

