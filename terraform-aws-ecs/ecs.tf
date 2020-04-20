# ecs.tf

### ecs cluster
resource "aws_ecs_cluster" "this" {
  #count = var.create_ecs ? 1 : 0
  name = var.ecs_cluster_name
}

### tasks definition
resource "aws_ecs_task_definition" "this" {
  count                    = length(var.services)
  requires_compatibilities = [local.cluster_type]
  family                   = "${local.task_name}-${count.index}"
  network_mode             = "awsvpc"
  cpu                      = lookup(var.services[count.index], "cpu", "256")
  memory                   = lookup(var.services[count.index], "mem", "512")
  execution_role_arn       = aws_iam_role.taskrun.arn
  container_definitions    = file(var.services[count.index]["task_file"])
}

### service definition
resource "aws_ecs_service" "this" {
  count = length(var.services)
  name = lookup(
    var.services[count.index],
    "name",
    "${local.task_name}-${count.index}",
  )
  cluster             = aws_ecs_cluster.this.id
  launch_type         = local.cluster_type
  task_definition     = aws_ecs_task_definition.this[count.index].arn
  scheduling_strategy = lookup(var.services[count.index], "scheduling", "REPLICA")
  desired_count       = lookup(var.services[count.index], "desired_count", "1")

  network_configuration {
    subnets = var.subnets
    security_groups = [lookup(
      var.services[count.index],
      "security_groups",
      element(data.aws_security_groups.default.ids, 0),
    )]
  }

  lifecycle {
    create_before_destroy = true
  }
}

