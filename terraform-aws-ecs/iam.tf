# iam.tf
# iam roles and policies for ecs cluster and tasks

# current region
data "aws_region" "current" {
}

locals {
  alias_service = substr(data.aws_region.current.name, 0, 2) == "cn" ? "amazonaws.com.cn" : "amazonaws.com"
}

### role, ec2 cluster
resource "aws_iam_role" "ec2cluster" {
  name               = local.cluster_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.cluster_trust_rel.json
}

data "aws_iam_policy_document" "cluster_trust_rel" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.${local.alias_service}",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "ec2cluster" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ec2cluster" {
  override_json = data.aws_iam_policy.ec2cluster.policy

  statement {
    actions   = ["iam:Simulate*"]
    effect    = "Deny"
    resources = ["*"]
  }
}

# attach policies
resource "aws_iam_role_policy" "ec2cluster" {
  name   = local.cluster_name
  role   = aws_iam_role.ec2cluster.id
  policy = data.aws_iam_policy_document.ec2cluster.json
}

# instance profiles
resource "aws_iam_instance_profile" "ec2cluster" {
  name = local.cluster_name
  role = aws_iam_role.ec2cluster.name
}

### role, task execution

resource "aws_iam_role" "taskrun" {
  name               = "${local.name}-taskrun"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.task_trust_rel.json
}

data "aws_iam_policy_document" "task_trust_rel" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.${local.alias_service}",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "taskrun" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "taskrun" {
  override_json = data.aws_iam_policy.taskrun.policy

  statement {
    actions   = ["iam:Simulate*"]
    effect    = "Deny"
    resources = ["*"]
  }
}

# attach policies
resource "aws_iam_role_policy" "taskrun" {
  name   = "${local.name}-taskrun"
  role   = aws_iam_role.taskrun.id
  policy = data.aws_iam_policy_document.taskrun.json
}

