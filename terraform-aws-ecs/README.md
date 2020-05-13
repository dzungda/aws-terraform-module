# ECS Terraform module

## Using module
You can use this module like as below example.

### EC2 based cluster
This is an exmaple to show how to create a ecs cluster using ec2 autoscaling group.
```
module "your_ecs" {
  source  = "https://github.com/dzungda/aws-terraform-module/new/master/terraform-aws-ecs"

  app_name       = "yecs-basic"
  app_short_name = "yecs-b"
  app_detail     = "test"
  stack_name     = "apne2"
  region         = var.aws_region
  vpc            = data.terraform_remote_state.vpc.outputs.vpc_id
  azs            = data.terraform_remote_state.vpc.outputs.azs
  subnets        = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  cluster = {
    "type"              = "EC2",
    "instance_type"     = "t2.medium",
    "ssh_port"          = var.ssh_port,
    "node_vol_size"     = "1024",
    "node_min_size"     = "4",
    "node_max_size"     = "6",
    "node_desired_size" = "4",
  }

  services = [{
    "name"      = "test-fargate-nginx",
    "task_file" = "${path.cwd}/tasks/nginx.json",
    }
  ]

  tags = [{
    "key"                 = "env",
    "value"               = "test",
    "propagate_at_launch" = "true",
    }
  ]
}
```

### Fargate cluster
This is an example to show how to create a fargate cluster and deploy two service.

```
module "your_fagt" {
  source  = "https://github.com/dzungda/aws-terraform-module/new/master/terraform-aws-ecs"

  app_name       = "yfagt-basic"
  app_short_name = "yfgat-b"
  app_detail     = "test"
  stack_name     = "apne2"
  region         = var.aws_region
  vpc            = data.terraform_remote_state.vpc.outputs.vpc_id
  azs            = data.terraform_remote_state.vpc.outputs.azs
  subnets        = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  cluster = {
    "type" = "FARGATE",
  }

  services = [{
      "name" = "test-fargate-nginx",
      "task_file" = "${path.cwd}/tasks/nginx.json",
    },
    {
      "name" = "test-fargate-wordpress",
      "task_file" = "${path.cwd}/tasks/wordpress.json"
    },
  ]
}
```

