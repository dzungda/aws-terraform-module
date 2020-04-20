### default

locals {
  cluster_type      = lookup(var.cluster, "type", "EC2")
  is_fargate        = local.cluster_type == "EC2" ? false : true
  instance_type     = lookup(var.cluster, "instance_type", "m5.large")
  node_min_size     = lookup(var.cluster, "node_min_size", "3")
  node_max_size     = lookup(var.cluster, "node_max_size", "3")
  node_desired_size = lookup(var.cluster, "node_desired_size", "3")
  node_vol_size     = lookup(var.cluster, "node_vol_size", "8")
  ssh_port          = lookup(var.cluster, "ssh_port", "2080")
  ssh_key           = lookup(var.cluster, "ssh_key", "")
  cluster_name = var.cluster_name
  task_name = var.task_name
  name = var.name
}

